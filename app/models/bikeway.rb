# == Schema Information
#
# Table name: bikeways
#
#  id                   :integer          not null, primary key
#  bikeway_name         :string(255)
#  portion              :integer
#  description          :string(255)
#  length_m             :integer
#  bikeway_route_number :integer
#

class Bikeway < ActiveRecord::Base
  has_many :bikeway_segments

  def to_s
    "#{bikeway_name} (pt #{portion}, #{length_m} m)"
  end
end
