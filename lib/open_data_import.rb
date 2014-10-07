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
    for id in BikewaySegment.all_feature_ids
      walker = FeatureWalker.new(feature_id: id)
      paths = walker.paths

      path_ids = paths.map { |list| list.map { |path| path.id } }

      if path_ids.length > 1
        puts "lfn_id=#{id} full_street_name=#{BikewaySegment.full_street_name(id)} num_paths=#{paths.length} paths:"
        puts "  --> #{path_ids}"
      end
    end
  end

end









