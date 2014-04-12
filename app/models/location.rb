# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  latlon     :spatial          point, 4326
#  created_at :datetime
#  updated_at :datetime
#

class Location < ActiveRecord::Base
  set_rgeo_factory_for_column(:latlon,
    RGeo::Geographic.spherical_factory(:srid => 4326))
end
