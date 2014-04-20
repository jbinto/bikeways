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

require 'spec_helper'

describe BikewaySegment do

  # XXX HACK FIXME:
  # This is a pretty brittle test.
  # Excuse: I wanted to get *something* done in a TDD fashion to whet my appetite.
  #
  # Problems with this test:
  # 1) It has hardcoded expected and actuals that are opaque and based on the result
  #    of running it by hand in postgresql.
  #
  # 2) It is tightly coupled to the SRID of the database (though perhaps this could be
  #    argued to be a poor-mans-smoke-test, if the SRID ever changes this will fail)
  #
  # 3) It actually hits the DB, which is bad form, but so is the .kml method itself.
  #
  # 4) The rounding/floating point semantics may change between platforms/implementations.

  # It does function as a fine smoke test to ensure the SRID is correct.

  it "should be able to render itself as KML" do
    segment = FactoryGirl.create(:bikeway_segment,
      :geom => "MULTILINESTRING ((-79.521209665 43.590895067, -79.522533939 43.590800049))")

    actual = segment.kml
    expected = "<MultiGeometry><LineString><coordinates>-79.521209665000001,43.590895066999998 -79.522533938999999,43.590800049000002</coordinates></LineString></MultiGeometry>"

    expect(actual).to eq(expected)
  end

end
