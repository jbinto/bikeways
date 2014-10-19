require 'gis_tools'

class Segment < ActiveRecord::Base

  def self.all_feature_ids
    Segment.pluck(:city_linear_feature_name_id).uniq.sort
  end

  def self.full_street_name(feature_id)
    Segment.where(:city_linear_feature_name_id => feature_id).first!.full_street_name
  end

  def kml
    result = Segment.select('*, st_askml(st_transform(geom, 4326)) as _kml').where(:id => self.id).first
    result._kml
  end

  def next
    # NOTE: strong assumption that this will return exactly 1 or 0 records
    # undefined behaviour if it returns >1 record, should detect this
    Segment.where(
      from_intersection_id: self.to_intersection_id,
      city_linear_feature_name_id: self.city_linear_feature_name_id
    ).first
  end

  def prev
    Segment.where(
      to_intersection_id: self.from_intersection_id,
      city_linear_feature_name_id: self.city_linear_feature_name_id
    ).first
  end

  # XXX: this is view level stuff, move it to a helper or something
  # certainly not in the model.
  def style_id
    STYLE_ID_CODES[self.bikeway_type]
  end

  def length_calculated
    GISTools.length_m(self.geom)
  end
end
