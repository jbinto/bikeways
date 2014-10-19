require 'gis_tools'

class Segment < ActiveRecord::Base

  def self.total_length_km
    (Segment.sum(:length_m)/1024).round(2)
  end

  def kml
    result = Segment.select('*, st_askml(st_transform(geom, 4326)) as _kml').where(:id => self.id).first
    result._kml
  end

  # XXX: this is view level stuff, move it to a helper or something
  # certainly not in the model.
  def style_id
    STYLE_ID_CODES[self.bikeway_type]
  end

  def to_s
    "#{full_street_name} (#{length_m.round(1)} m)"
  end

end
