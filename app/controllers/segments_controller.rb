class SegmentsController < ApplicationController
  def index
    @segments = BikewaySegment.limit(100)
  end
end
