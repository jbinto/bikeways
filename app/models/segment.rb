require 'gis_tools'

class Segment < ActiveRecord::Base

  scope :bikeway_type, ->(type) { where("bikeway_type = ?", type) }
  scope :full_street_name, ->(name) { where("full_street_name = ?", name) }

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

  def name_with_range
    "#{range} #{full_street_name}"
  end

  def description
    "#{name_with_range} (#{bikeway_type}, #{length_m.round(1)} m)"
  end

  def to_s
    description
  end

  def range
    max = [highest_address_left, highest_address_right].reject { |n| nil_or_zero?(n) }.max
    min = [lowest_address_left, lowest_address_right].reject { |n| nil_or_zero?(n)  }.min

    if nil_or_zero?(min) && nil_or_zero?(max)
      nil
    else
      "#{min}-#{max}"
    end
  end

  private
  def nil_or_zero?(n)
    n.nil? || n == 0
  end

end
