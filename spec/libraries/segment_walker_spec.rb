require 'spec_helper'
require 'segment_walker'

describe SegmentWalker do

  let!(:different_before_first) { FactoryGirl.create(:bikeway_segment, :city_linear_feature_name_id => 300, :from_intersection_id => 500, :to_intersection_id => 1) }
  let!(:first)  { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 1, :to_intersection_id => 2) }
  let!(:second) { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 2, :to_intersection_id => 3) }
  let!(:third)  { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 3, :to_intersection_id => 4) }
  let!(:fourth) { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 4, :to_intersection_id => 5) }
  let!(:fifth)  { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 5, :to_intersection_id => 1000) }
  let!(:different_after_second) { FactoryGirl.create(:bikeway_segment, :city_linear_feature_name_id => 50, :from_intersection_id => 1000, :to_intersection_id => 1001) }

  it "should be able to arrange segments of a feature in their natural order" do

    walker = SegmentWalker.new(segment_id: third.id)

    actual = walker.ordered_segments
    expected = [first, second, third, fourth, fifth]

    expect(actual).to eq(expected)
  end
end
