require 'bikeway_segments_datatable'

class BikewaySegmentsController < ApplicationController
  def index
    @segments = nil

    respond_to do |format|
      format.html  # index.html.haml
      format.json {
        render json: BikewaySegmentsDatatable.new(view_context)
      }
    end
  end

  def show
    @segment = BikewaySegment.find params[:id]
  end
end
