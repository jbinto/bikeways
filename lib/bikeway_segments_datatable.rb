# Adapted from http://railscasts.com/episodes/340-datatables?view=asciicast
# All of this un-ruby-like hungarian notation comes from datatables.net - don't blame me ;)

class BikewaySegmentsDatatable
  delegate :params, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: BikewaySegment.count,
      iTotalDisplayRecords: segments.total_entries,
      aaData: data
    }
  end

  private
  def data
    segments.map do |segment|
      [
        link_to(segment.id, segment),
        ERB::Util.h(segment.city_rid),
        ERB::Util.h(segment.city_geo_id),
        ERB::Util.h(segment.city_linear_feature_name_id),
        ERB::Util.h(segment.city_object_id),
        ERB::Util.h(segment.full_street_name),
        ERB::Util.h(segment.address_left),
        ERB::Util.h(segment.address_right),
        ERB::Util.h(segment.odd_even_flag_left),
        ERB::Util.h(segment.odd_even_flag_right),
        ERB::Util.h(segment.lowest_address_left),
        ERB::Util.h(segment.lowest_address_right),
        ERB::Util.h(segment.highest_address_left),
        ERB::Util.h(segment.highest_address_right),
        ERB::Util.h(segment.from_intersection_id),
        ERB::Util.h(segment.to_intersection_id),
        ERB::Util.h(segment.street_classification),
        ERB::Util.h(segment.bikeway_type)
      ]
    end
  end

  def segments
    @segments ||= fetch_segments
  end

  def fetch_segments
    segments = BikewaySegment.order("#{sort_column} #{sort_direction}")
    segments = segments.page(page).per_page(per_page)
    if params[:sSearch].present?
      where = '' \
        'full_street_name ilike :search' \
        ' or bikeway_type ilike :search' \
        ' or street_classification ilike :search' \
        ' or cast(city_linear_feature_name_id as text) ilike :search'
      segments = segments.where(where, search: "%#{params[:sSearch]}%")
    end
    segments
  end

  def page
    params[:iDisplayStart].to_i / per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = [
      "id",
      "city_rid",
      "city_geo_id",
      "city_linear_feature_name_id",
      "city_object_id",
      "full_street_name",
      "address_left",
      "address_right",
      "odd_even_flag_left",
      "odd_even_flag_right",
      "lowest_address_left",
      "lowest_address_right",
      "highest_address_left",
      "highest_address_right",
      "from_intersection_id",
      "to_intersection_id",
      "street_classification",
      "bikeway_type"
    ]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end