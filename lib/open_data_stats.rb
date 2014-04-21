# n.b. for this purpose, "feature" means "LINEAR FEATURE" a.k.a. a road or route.

require 'segment_walker'

class OpenDataStats
  def walk_all_routes
    for id in all_feature_ids
      puts "scanning feature lfn=#{id}..."

      # not in sequence, directly from database
      segments = segments_by_feature_id(id)

      puts "  found #{segments.count} segments in the database"

      # take the first segment, could be anywhere within this feature
      arbitrary_segment = segments.first
      puts "  full_street_name: #{arbitrary_segment.full_street_name}"
      puts "  arbitrarily selecting segment id=#{arbitrary_segment.id} to pass to SegmentWalker"

      walker = SegmentWalker.new(segment: arbitrary_segment)
      walked_segments = walker.ordered_segments

      puts "  found #{walked_segments.count} segments by walking the route"


      if segments.count == walked_segments.count
        puts " counts match, good"
      else
        puts " counts DIFFER! BAD! ********* <----------"
      end
    end
  end

  def all_feature_ids
    BikewaySegment.pluck(:city_linear_feature_name_id).uniq.sort
  end

  def segments_by_feature_id(id)
    BikewaySegment.where(:city_linear_feature_name_id => id)
  end
end