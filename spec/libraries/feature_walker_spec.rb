require 'feature_walker'

describe FeatureWalker do
  describe "straight continuous line" do
    let!(:first)  { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 1, :to_intersection_id => 2) }
    let!(:second) { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 2, :to_intersection_id => 3) }
    let!(:third)  { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 3, :to_intersection_id => 4) }
    let!(:fourth) { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 4, :to_intersection_id => 5) }
    let!(:fifth)  { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 5, :to_intersection_id => 1000) }

    it "should walk a simple straight-line feature successfully" do

      feature_walker = FeatureWalker.new(feature_id: 1)
      actual = feature_walker.paths
      expected = [[first, second, third, fourth, fifth]]

      expect(actual).to eq(expected)
    end
  end


  describe "discontiguous lines" do
    let!(:first)  { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 1, :to_intersection_id => 2) }
    let!(:second) { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 2, :to_intersection_id => 3) }
    let!(:third)  { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 3, :to_intersection_id => 1000) }
    let!(:other_part_first) { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 4000, :to_intersection_id => 4001) }
    let!(:other_part_second)  { FactoryGirl.create(:bikeway_segment, :from_intersection_id => 4001, :to_intersection_id => 9999) }

    it "should walk all discontiguous paths with the same feature id" do

      feature_walker = FeatureWalker.new(feature_id: 1)
      actual = feature_walker.paths

      # how will we know what order the paths will come in?
      expected = [[first, second, third], [other_part_first, other_part_second]]

      expect(actual).to eq(expected)
    end
  end

end