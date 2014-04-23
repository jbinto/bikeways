require 'logging_helpers'

class FeatureWalker
  def initialize(opts)
    @feature_id = nil
    if opts.key?(:feature_id)
      @feature_id = opts[:feature_id]
    end
  end

  def paths
    paths = []

    all_segments = segments_by_feature_id(@feature_id)
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

  def all_feature_ids
    BikewaySegment.pluck(:city_linear_feature_name_id).uniq.sort
  end

  def segments_by_feature_id(id)
    BikewaySegment.where(:city_linear_feature_name_id => id)
  end
end