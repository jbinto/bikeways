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
