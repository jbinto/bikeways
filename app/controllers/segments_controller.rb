require 'segments_datatable'

class SegmentsController < ApplicationController
  has_scope :bikeway_type

  def index
    @segments = apply_scopes(Segment).all
    @kml_url = url_for current_scopes.merge(:controller => :segments, :action => :index, :format => :kml)
    @json_url = url_for current_scopes.merge(:controller => :segments, :action => :index, :format => :json)

    respond_to do |format|
      format.html  # index.html.haml
      format.json {
        render json: SegmentsDatatable.new(view_context, @segments)
      }
      format.kml {
        render template: 'shared/kml'
      }
    end
  end

  def show
    raise 'oops'
  end

end
