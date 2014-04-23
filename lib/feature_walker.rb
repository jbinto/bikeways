require 'logging_helpers'

class FeatureWalker
  def initialize(opts)
    @feature_id = nil
    if opts.key?(:feature_id)
      @feature_id = opts[:feature_id]
    end
  end

  # Analyzes the feature pointed to by @feature_id, and returns an array containing all contiguous paths.
  # Each entry in the returned array is itself an array of BikewaySegment records, in the correct sequence*.
  # For example:
  #    [[a,b,c], [d,e]]
  #    where all letters are BikewaySegments;
  #    a,b,c are one contiguous part of the feature;
  #    d,e are another contiguous part of the feature.
  def paths
    paths = []

    all_segments = find_segments_by_feature_id(@feature_id)
    unwalked_segments = all_segments
    i=1
    until unwalked_segments.empty? do
      walked_segments = build_path(unwalked_segments)
      paths << walked_segments

      unwalked_segments = all_segments - paths.flatten
      if unwalked_segments.count > 0
        debug " [#{@feature_id}] iteration #{i+=1}: #{unwalked_segments.count} unwalked segments remaining"
      end
    end

    paths
  end

  private
  def find_segments_by_feature_id(id)
    BikewaySegment.where(:city_linear_feature_name_id => id)
  end

  # Builds a single path from the list of segments passed in.
  # The entire `segments` array is passed in for better logging,
  # though technically, only the first element is considered.
  # The selection of the first element is arbitrary.
  #
  # The caller of this method is responsible for keeping track
  # of which segments have been visited and which have not.
  def build_path(segments)
    segment = segments.first

    debug \
      "#{segment.full_street_name} " \
      "(lfn_id=#{segment.city_linear_feature_name_id}); " \
      "id=#{segment.id}; " \
      "geoid=#{segment.city_geo_id}; " \
      "#{segments.count} segments in db; \n"

    walker = SegmentWalker.new(segment: segment)
    walked_segments = walker.ordered_segments

    print "#{walked_segments.count} segments found by walking; "

    walked_segments
  end

end