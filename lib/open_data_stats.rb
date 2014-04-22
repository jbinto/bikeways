# n.b. for this purpose, "feature" means "LINEAR FEATURE" a.k.a. a road or route.

require 'segment_walker'

class OpenDataStats
  def walk_all_routes
    for id in all_feature_ids
      # not in sequence, directly from database
      segments = segments_by_feature_id(id)

      # take the first segment, could be anywhere within this feature
      arbitrary_segment = segments.first
      print "#{arbitrary_segment.full_street_name} (lfn_id=#{id}); "
      print "id=#{arbitrary_segment.id}; "
      print "geoid=#{arbitrary_segment.city_geo_id}; "
      print "#{segments.count} segments in db; "

      walker = SegmentWalker.new(segment: arbitrary_segment)
      walked_segments = walker.ordered_segments

      print "#{walked_segments.count} segments found by walking; "

      if segments.count == walked_segments.count
        puts "counts match, good"
      else
        puts "BAD! counts DO NOT MATCH!"

        # which ones did we walk? we need to compare to the ones 
        walked_ids = walked_segments.map { |x| x.id }
        segment_ids = segments.map {|x| x.id }
        difference = segment_ids - walked_ids

        puts "  offenders: #{difference}"
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