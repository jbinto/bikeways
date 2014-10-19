require 'bikeway_segments_datatable'

class SegmentsController < ApplicationController
  def index
    @segments = nil

    respond_to do |format|
      format.html  # index.html.haml
      format.json {
        render json: SegmentsDatatable.new(view_context)
      }
    end
  end

  def show
    @segments = [Segment.find(params[:id])]
    @kml_url = url_for(:controller => :bikeway_segments, :action => :show, :format => :kml)

    respond_to do |format|
      format.html
      format.kml {
        render template: 'shared/kml'
      }
    end
  end

  def next
    segment = Segment.find params[:id]
    redirect_to_segment segment.next
  end

  def prev
    segment = Segment.find params[:id]
    redirect_to_segment segment.prev
  end

  def redirect_to_segment(segment)
    if segment.blank?
      redirect_to :back, alert: "That's as far as you can go."
    else
      redirect_to segment
    end
  end

end
