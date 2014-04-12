class LoadShapefile < ActiveRecord::Migration

  SHAPEFILE = Rails.root.join('vendor', 'opendata', 'CENTRELINE_BIKEWAY_OD')

  def up
    BikewaySegment.delete_all

    factory = RGeo::Geographic.spherical_factory(:srid => 2019)
    RGeo::Shapefile::Reader.open('vendor/opendata/CENTRELINE_BIKEWAY_OD', :factory => factory) do |file|
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
