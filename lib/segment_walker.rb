class SegmentWalker
  def initialize(opts)
    @segment = nil
    if opts.key?(:segment_id)
      @segment = BikewaySegment.find(opts[:segment_id])
    end
  end

  def ordered_segments
    segments = []

    # don't clobber the instance variable...
    segment = @segment

    # current segment is the "middle" or the pivot
    pivot = segment
    segments.push(pivot)

    # first walk forwards...
    until segment.nil?
      segment = segment.next
      segments.push(segment) unless segment.nil?
    end

    # go back to the pivot, then walk backwards
    segment = pivot
    until segment.nil?
      segment = segment.prev
      segments.unshift(segment) unless segment.nil?
    end

    segments
  end
end