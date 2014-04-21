require 'spec_helper'
require 'segment_walker'

describe SegmentWalker do

  describe "#ordered_segments" do

    let!(:different_before_first) { FactoryGirl.create(:bikeway_segment, :city_linear_feature_name_id => 300, :from_intersection_id => 500, :to_intersection_id => 1) }
    let!(:first)  { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 1, :to_intersection_id => 2) }
    let!(:second) { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 2, :to_intersection_id => 3) }
    let!(:third)  { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 3, :to_intersection_id => 4) }
    let!(:fourth) { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 4, :to_intersection_id => 5) }
    let!(:fifth)  { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 5, :to_intersection_id => 1000) }
    let!(:different_after_second) { FactoryGirl.create(:bikeway_segment, :city_linear_feature_name_id => 50, :from_intersection_id => 1000, :to_intersection_id => 1001) }

    def test_ordered_segments(walker)
      actual = walker.ordered_segments
      expected = [first, second, third, fourth, fifth]
      expect(actual).to eq(expected)
    end

    it "should work from the middle" do
      test_ordered_segments(SegmentWalker.new(segment_id: third.id))
    end

    it "should work from the left" do
      test_ordered_segments(SegmentWalker.new(segment_id: first.id))
    end

    it "should work from the right" do
      test_ordered_segments(SegmentWalker.new(segment_id: fifth.id))
    end

    it "can accept a segment object directly" do
      test_ordered_segments(SegmentWalker.new(segment: fifth))
    end

  end

  describe "cyclic data" do
    let!(:one)   { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 11, :to_intersection_id => 22) }
    let!(:two)   { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 22, :to_intersection_id => 33) }
    let!(:three) { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 33, :to_intersection_id => 11) }

    it "can handle cycles without going into infinite loop" do
      walker = SegmentWalker.new(segment: one)
      actual = walker.ordered_segments
      expected = [one, two, three]

      expect(actual).to eq(expected)

    end
  end

end
