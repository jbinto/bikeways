require 'gis_tools'
# == Schema Information
#
# Table name: bikeway_segments
#
#  id                          :integer          not null, primary key
#  city_rid                    :integer
#  city_geo_id                 :integer
#  city_linear_feature_name_id :integer
#  city_object_id              :integer
#  full_street_name            :string(255)
#  address_left                :string(255)
#  address_right               :string(255)
#  odd_even_flag_left          :string(255)
#  odd_even_flag_right         :string(255)
#  lowest_address_left         :integer
#  lowest_address_right        :integer
#  highest_address_left        :integer
#  highest_address_right       :integer
#  from_intersection_id        :integer
#  to_intersection_id          :integer
#  street_classification       :string(255)
#  bikeway_type                :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#  geom                        :spatial          geometry, 4326
#  bikeway_id                  :integer
#  length_m                    :float
#

class BikewaySegment < ActiveRecord::Base
  belongs_to :bikeway

  def self.all_feature_ids
    BikewaySegment.pluck(:city_linear_feature_name_id).uniq.sort
  end

  def self.full_street_name(feature_id)
    BikewaySegment.where(:city_linear_feature_name_id => feature_id).first!.full_street_name
  end

  def kml
    result = BikewaySegment.select('*, st_askml(st_transform(geom, 4326)) as _kml').where(:id => self.id).first
    result._kml
  end

  def next
    # NOTE: strong assumption that this will return exactly 1 or 0 records
    # undefined behaviour if it returns >1 record, should detect this
    BikewaySegment.where(
      from_intersection_id: self.to_intersection_id,
      city_linear_feature_name_id: self.city_linear_feature_name_id
    ).first
  end

  def prev
    BikewaySegment.where(
      to_intersection_id: self.from_intersection_id,
      city_linear_feature_name_id: self.city_linear_feature_name_id
    ).first
  end

  # XXX: this is view level stuff, move it to a helper or something
  # certainly not in the model.
  def style_id
    STYLE_ID_CODES[self.bikeway_type]
  end

  def length_calculated
    GISTools.length_m(self.geom)
  end
end
