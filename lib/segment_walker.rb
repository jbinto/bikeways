class SegmentWalker
  def initialize(opts)
    @segment = nil
    if opts.key?(:segment)
      @segment = opts[:segment]
    elsif opts.key?(:segment_id)
      @segment = BikewaySegment.find(opts[:segment_id])
    end
  end

  def ordered_segments
    @segments = []
    @cycle = false

    # don't clobber the instance variable...
    segment = @segment

    # current segment is the "middle" or the pivot
    pivot = segment
    @segments.push(pivot)

    # first walk forwards...
    until segment.nil?
      segment = segment.next
      break unless process_segment(segment) do |segment|
        @segments.push(segment)
      end
    end

    # go back to the pivot, then walk backwards
    segment = pivot
    until segment.nil?
      segment = segment.prev
      break unless process_segment(segment) do |segment|
        @segments.unshift(segment)
      end
    end

    @segments
  end

  def process_segment(segment, &block)
    if segment.nil?
      return false
    elsif @segments.include?(segment)
      # cycle detected! segment already seen! breaking out!"
      @cycle = true
      return false
    else
      yield segment
    end
  end
end