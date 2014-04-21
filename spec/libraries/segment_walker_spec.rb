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

  it "ordered_segments should work from the middle" do
    test_ordered_segments(third.id)
  end

  it "ordered_segments should work from the left" do
    test_ordered_segments(first.id)
  end

  it "ordered_segments should work from the right" do
    test_ordered_segments(fifth.id)
  end

  def test_ordered_segments(segment_id)
    walker = SegmentWalker.new(segment_id: third.id)
    actual = walker.ordered_segments
    expected = [first, second, third, fourth, fifth]
    expect(actual).to eq(expected)
  end

end
