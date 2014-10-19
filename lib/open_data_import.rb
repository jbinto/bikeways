require 'httparty'
require 'zip'

require 'action_view'
include ActionView::Helpers::NumberHelper   # for number_to_human_size

require 'fileutils'
require 'open_data_file'
require 'gis_tools'

require 'ruby-progressbar'

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

    @progress = ProgressBar.create(starting_at: 0, total: nil, format: '%t %B %c/%C', throttle_rate: 1.0)
  end

  def reset
    @progress.title = "Downloading bikeway file"
    unless @bikeway_file.download
      puts "error downloading bikeway file, aborting"
      return
    end
    @progress.log "Successfully downloaded bikeway file"

    @progress.title = "Unzipping bikeway file"
    unless @bikeway_file.unzip
      puts "error unzipping bikeway file, aborting"
      return
    end
    @progress.log "Successfully unzipped bikeway file"

    @progress.title = "Importing bikeway file"
    unless import_bikeway_file
      puts "error importing bikeway file, aborting"
      return
    end
    @progress.log "Successfully imported bikeway file"

    @progress.title = "Flattening KML"
    unless flatten_kml
      puts "error flattening kml, aborting"
      return
    end
    @progress.log "Complete!"

    #unless populate_bikeway_table
  end

  def import_bikeway_file
    # Uses RGeo to import the city provided ESRI shapefile. Inserts the city record as-is
    # into a PostGIS table, `segments`.

    Segment.transaction do
      Segment.delete_all
      @progress.log "Deleted all segments"

      # http://stackoverflow.com/a/2097175/19779
      # Reset the PK so that the IDs are at least consistent between environments / subsequent imports.
      ActiveRecord::Base.connection.reset_pk_sequence!('segments')

      factory = RGeo::Geographic.spherical_factory(:srid => 4326)
      RGeo::Shapefile::Reader.open(@bikeway_file.shapefile, :factory => factory) do |file|
        @progress.title = "Importing bikeways shapefile"
        #index = 0

        @progress.total = file.num_records
        file.each do |record|
          #index += 1
          #puts "#{index} records scanned" if index % 1000 == 0
          @progress.increment

          # The bikeways file includes all city streets.
          # Only bikeways will have CP_TYPE set, and that's all we're interested in.
          if record["CP_TYPE"].empty?
            next
          end

          Segment.create do |s|
            # XXX: normalize the street name here?
            s.full_street_name = record["LF_NAME"]

            s.lowest_address_left = record["LONUML"]
            s.lowest_address_right = record["LONUMR"]
            s.highest_address_left = record["HINUML"]
            s.highest_address_right = record["HINUMR"]
            s.bikeway_type = record["CP_TYPE"]

            s.geom = record.geometry
            s.length_m = GISTools.length_m(s.geom)
          end
        end
      end

      @city_total_length_km = Segment.total_length_km
    end

    @progress.log "Imported #{Segment.count} segments"
    @progress.reset
    true
  end

  def flatten_kml
    # The city provided KML can be simplified (higher granularity)
    # by representing each contiguous route as a single linestring.

    # We lose some metadata, but it makes the volume more manageable.

    Segment.transaction do
      # Grab the coarse-grained segments...
      flattened_segments = GISTools::street_union
      @progress.log "Flattening Segment geometries from #{Segment.count} to #{flattened_segments.count}"

      # ...delete the original city's fine-grained data (appx 6800)...
      Segment.delete_all
      @progress.log "Deleted all Segment records"

      @progress.total = flattened_segments.count

      # ...and now add the coarse-grained (appx 800).
      flattened_segments.each do |segment|
        Segment.create do |new_segment|
          new_segment.update_attributes segment
          new_segment.length_m = GISTools.length_m new_segment.geom
          @progress.log "-> added: #{new_segment.to_s}"
          @progress.increment
        end
      end

      @progress.log "Successfully added #{Segment.count} flattened Segment records."
      @progress.log "Total length from opendata file: #{@city_total_length_km}"
      @progress.log "Total length (after flattening): #{Segment.total_length_km} km"
    end

    true
  end

end #class







