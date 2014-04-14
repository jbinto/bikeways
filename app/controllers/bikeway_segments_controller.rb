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
    @kml_url = url_for(:controller => :bikeway_segments, :action => :show, :format => :kml)

    respond_to do |format|
      format.html
      format.kml {
        render template: 'bikeway_segments/kml'
      }
    end
  end
end
