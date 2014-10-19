# Adapted from http://railscasts.com/episodes/340-datatables?view=asciicast
# All of this un-ruby-like hungarian notation comes from datatables.net - don't blame me ;)

class SegmentsDatatable
  #include Rails.application.routes.url_helpers

  delegate :params, :link_to, :root_path, to: :@view

  def initialize(view, segments)
    @view = view
    @segments_in = segments
  end

  def as_json(options = {})
    {
      draw: params[:draw].to_i,
      recordsTotal: Segment.count,
      recordsFiltered: segments.total_entries,
      data: data
    }
  end

  private
  def data
    segments.map do |segment|
      [
        ERB::Util.h(segment.id),
        link_to(segment.name_with_range, root_path(:full_street_name => segment.full_street_name)),
        ERB::Util.h(segment.lowest_address_left),
        ERB::Util.h(segment.lowest_address_right),
        ERB::Util.h(segment.highest_address_left),
        ERB::Util.h(segment.highest_address_right),
        link_to(segment.bikeway_type, root_path(:bikeway_type => segment.bikeway_type)),
        ERB::Util.h(segment.length_m)
      ]
    end
  end

  def segments
    @segments ||= fetch_segments
  end

  def fetch_segments
    @segments = @segments_in
    @segments = @segments.order("#{sort_column} #{sort_direction}")
    @segments = @segments.page(page).per_page(per_page)
    if params[:search][:value].present?
      where = '' \
        'full_street_name ilike :search' \
        ' or bikeway_type ilike :search' \
        ' or cast(id as text) ilike :search'
      @segments = @segments.where(where, search: "%#{params[:search][:value]}%")
    end
    @segments
  end

  def page
    params[:start].to_i / per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def sort_column
    columns = [
      "id",
      "full_street_name",
      "lowest_address_left",
      "lowest_address_right",
      "highest_address_left",
      "highest_address_right",
      "bikeway_type",
      "length_m"
    ]
    sort_col = params[:order]['0']['column'].to_i
    columns[sort_col]
  end

  def sort_direction
    params[:order]['0'][:dir] == "desc" ? "desc" : "asc"
  end

end