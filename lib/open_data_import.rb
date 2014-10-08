require 'httparty'
require 'zip'

require 'action_view'
include ActionView::Helpers::NumberHelper   # for number_to_human_size

require 'fileutils'
require 'open_data_file'

## TODO: Unit test this class using fakefs gem (& figure out how to mock out Zip somehow)
class OpenDataImport
  BIKEWAYS_URL = 'http://opendata.toronto.ca/gcc/bikeways_wgs84.zip'
  BIKEWAYS_ZIPFILE = File.join(OpenDataFile::OPENDATA_DIR, 'bikeways_wgs84.zip')
  BIKEWAYS_SHAPEFILE = File.join(OpenDataFile::OPENDATA_DIR, 'CENTRELINE_BIKEWAY_OD_WGS84')

  def initialize(opts = {})
    @force = opts[:force] ||= false

    @bikeway_file = OpenDataFile.new(
      url: BIKEWAYS_URL,
      zipfile: BIKEWAYS_ZIPFILE,
      shapefile: BIKEWAYS_SHAPEFILE,
      force: @force
    )
  end

  def reset
    @bikeway_file.download && @bikeway_file.unzip && import_bikeway_file
    populate_bikeway_table
  end

  def import_bikeway_file
    BikewaySegment.transaction do
      BikewaySegment.delete_all

      # http://stackoverflow.com/a/2097175/19779
      # Reset the PK so that the IDs are at least consistent between environments / subsequent imports.
      ActiveRecord::Base.connection.reset_pk_sequence!('bikeway_segments')

      factory = RGeo::Geographic.spherical_factory(:srid => 4326)
      RGeo::Shapefile::Reader.open(@bikeway_file.shapefile, :factory => factory) do |file|
        index = 0
        file.each do |record|
          index += 1
          puts "#{index} records scanned" if index % 1000 == 0

          if record["CP_TYPE"].empty?
            next
          end

          BikewaySegment.create do |s|
            s.city_rid = record["RID"]
            s.city_geo_id = record["GEO_ID"]
            s.city_linear_feature_name_id = record["LFN_ID"]
            s.city_object_id = record["OBJECTID"]
            s.full_street_name = record["LF_NAME"]
            s.address_left = record["ADDRESS_L"]
            s.address_right = record["ADDRESS_R"]
            s.odd_even_flag_left = record["OE_FLAG_L"]
            s.odd_even_flag_right = record["OE_FLAG_R"]
            s.lowest_address_left = record["LONUML"]
            s.lowest_address_right = record["LONUMR"]
            s.highest_address_left = record["HINUML"]
            s.highest_address_right = record["HINUMR"]
            s.from_intersection_id = record["FNODE"]
            s.to_intersection_id = record["TNODE"]
            s.street_classification = record["FCODE_DESC"]
            s.bikeway_type = record["CP_TYPE"]

            s.geom = record.geometry
          end
        end
      end
    end
  end

  def populate_bikeway_table
    if Bikeway.count > 0
      puts "There are already #{Bikeway.count} Bikeway records, skipping populate_bikeway_table"
      return
    end

    Bikeway.transaction do
      Bikeway.delete_all

      # walk through each & every single BikewaySegment using FeatureWalker
      for id in BikewaySegment.all_feature_ids
        walker = FeatureWalker.new(feature_id: id)
        paths = walker.paths

        # console debugging
        path_ids = paths.map { |list| list.map { |path| path.id } }  # e.g. --> [[1561, 1601, 1602], [6124]]
        # e.g:
        #   lfn_id=3786 full_street_name=Kingston Rd num_paths=6 paths:
        #    --> [[1593, 1331, 1330, 1329, 1328, 1390, 1389, 1388], [1810], [1964, 6602], [2419, 2393, 2324, 4446, 2306], [5650, 2464, 2379, 2360], [4605]]
        puts "lfn_id=#{id} full_street_name=#{BikewaySegment.full_street_name(id)} num_paths=#{paths.length} paths:"
        puts "  --> #{path_ids}"


        # Since there are discontiguous routes that share the same street name, we have to divide
        # each distinct street name into contiguous portions.

        portion = 1
        paths.each do |segments|
          # create the Bikeway record for this portion
          bikeway = Bikeway.create do |b|
            b.bikeway_name = segments.first.full_street_name
            b.portion = portion
            b.description = "Insert description here."
            # b.bikeway_route_number = ...
          end
          puts "Created #{bikeway.to_s}"

          # point each of the BikewaySegments back to the Bikeway we just created
          segments.each do |segment|
            segment.bikeway = bikeway
            segment.save
          end

          portion += 1
        end
      end
    end # transaction
  end #def
end #class







