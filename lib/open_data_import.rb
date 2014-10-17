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
    # XXX: ugly, need some sort of state machine here?
    @bikeway_file.download && @bikeway_file.unzip && import_bikeway_file
    populate_bikeway_table
  end

  def import_bikeway_file
    # Uses RGeo to import the city provided ESRI shapefile. Inserts the city record as-is
    # into a PostGIS table, `bikeway_segments`.

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
    # The city data imported into `bikeway_segments` is appx. 6,500 lines on a map,
    # with little clearly defined logical relationship. This code exists to provide
    # some structure to these lines.
    #
    # A "Bikeway" is a logical grouping of bikeway_segments (e.g. the city provided records).
    #
    # This is created by applying several bits of logic. This code is messy.
    #
    # 1) The city provides "next/prev intersection" metadata for each `bikeway_segment`.
    #    This is the first level of grouping, and it is defined by the city's data.
    #
    # 2) We can also group by the `full_street_name` field, though keep in mind that just
    #    because a group of segments share a name doesn't mean they are geographically contiguous.
    #    This is why each Bikeway can have multiple `portion`s.
    #
    # The FeatureWalker handles both #1 and #2.


    Bikeway.transaction do
      Bikeway.delete_all

      # walk through each & every single BikewaySegment using FeatureWalker
      for id in BikewaySegment.all_feature_ids
        full_street_name = BikewaySegment.full_street_name(id)
        walker = FeatureWalker.new(feature_id: id)
        portions = walker.paths

        # console debugging
        nested_segment_ids = portions.map { |list| list.map { |path| path.id } }  # e.g. --> [[1561, 1601, 1602], [6124]]
        # e.g:
        #   lfn_id=3786 full_street_name=Kingston Rd num_portions=6 portions:
        #    --> [[1593, 1331, 1330, 1329, 1328, 1390, 1389, 1388], [1810], [1964, 6602], [2419, 2393, 2324, 4446, 2306], [5650, 2464, 2379, 2360], [4605]]
        puts "lfn_id=#{id} full_street_name=#{full_street_name} num_portions=#{portions.length} portions:"
        puts "  --> #{nested_segment_ids}"

        # Since there are discontiguous routes that share the same street name, we have to divide
        # each distinct street name into contiguous portions. For example, there's a bike lane
        # for a few 100m on Bayview Av near the Don Valley, and an entirely different part of town
        # there's another 100m stretch over a bridge. They're not the same route and shouldn't be
        # counted as such.

        if full_street_name.end_with? ' Trl'
          # The city data provided for trails should be grouped together even if it is geographically
          # discontiguous.
          portions = [portions.flatten]   # e.g. [[a,b,c],[d,e]] => [[a,b,c,d,e]]
        end

        portion = 1
        portions.each do |segments|
          # create the Bikeway record for this portion
          bikeway = Bikeway.create do |b|
            b.bikeway_name = segments.first.full_street_name
            b.portion = portion
            b.description = "Insert description here."
            # b.bikeway_route_number = ...
          end

          # point each of the BikewaySegments back to the Bikeway we just created
          segments.each do |segment|
            segment.bikeway = bikeway
            segment.save
          end

          puts "Created #{bikeway.to_s}"

          portion += 1
        end
      end
    end # transaction
  end #def


end #class







