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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bikeway_segment do
    city_id 1
    city_geo_id 1
    linear_feature_name_id 1
    full_street_name "MyString"
    address_left "MyString"
    address_right "MyString"
    odd_even_flag_left "MyString"
    odd_even_flag_right "MyString"
    lowest_address_left 1
    lowest_address_right 1
    highest_address_left 1
    highest_address_right 1
    from_intersection_id 1
    to_intersection_id 1
    street_classification "MyString"
    city_object_id 1
    bikeway_type "MyString"
    geom ""
  end
end
