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
#  geom                        :spatial          geometry, 2019
#

class BikewaySegment < ActiveRecord::Base
  belongs_to :bikeway

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

  # TODO: next_feature
  # or: separate next into "this_feature_only: true/fale"

end
