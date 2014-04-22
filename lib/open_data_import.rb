require 'httparty'
require 'zip'

require 'action_view'
include ActionView::Helpers::NumberHelper   # for number_to_human_size

require 'fileutils'

## TODO: Unit test this class using fakefs gem (& figure out how to mock out Zip somehow)

class OpenDataImport
  OPENDATA_URL = 'http://opendata.toronto.ca/gcc/bikeways_wgs84.zip'
  OPENDATA_DIR = Rails.root.join('vendor/opendata')
  OPENDATA_ZIP_FILE = File.join(OPENDATA_DIR, 'bikeways_wgs84.zip')
  OPENDATA_SHAPEFILE = Rails.root.join('vendor', 'opendata', 'CENTRELINE_BIKEWAY_OD_WGS84')

  def initialize(opts = {})
    @opendata_url = opts[:opendata_url] ||= OPENDATA_URL
    @opendata_dir = opts[:opendata_dir] ||= OPENDATA_DIR
    @opendata_zip_file = opts[:opendata_zip_file] ||= OPENDATA_ZIP_FILE
    @force = opts[:force] ||= false
  end

  def reset
    download && unzip && import
  end

  def download
    if File.exists?(OPENDATA_ZIP_FILE)
      print "#{OPENDATA_ZIP_FILE} already exists"
      unless @force
        puts ", please delete to redownload or use rake opendata:reset to start over"
        return false
      end
    end

    FileUtils.mkdir_p OPENDATA_DIR
    print "downloading #{OPENDATA_URL} ... "
    File.open(OPENDATA_ZIP_FILE, 'wb') do |f|
      len = f.write HTTParty.get(OPENDATA_URL).parsed_response
      puts "#{number_to_human_size(len)} received"
    end

    true
  end

  def unzip
    Zip::File.open(OPENDATA_ZIP_FILE) do |zip|
      zip.each do |file|
        dest = File.join('vendor/opendata', file.to_s)
        if File.exists? dest
          puts "already exists, skipping: #{file}"
          next
        end

        puts "extracting: #{file}"
        file.extract File.join('vendor/opendata', file.to_s)
      end
    end

    true
  end


  def import
    BikewaySegment.transaction do
      BikewaySegment.delete_all

      # http://stackoverflow.com/a/2097175/19779
      # Reset the PK so that the IDs are at least consistent between environments / subsequent imports.
      ActiveRecord::Base.connection.reset_pk_sequence!('bikeway_segments')

      factory = RGeo::Geographic.spherical_factory(:srid => 4326)
      RGeo::Shapefile::Reader.open('vendor/opendata/CENTRELINE_BIKEWAY_OD_WGS84', :factory => factory) do |file|
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

end









