class Bikeway < ActiveRecord::Base
  has_many :bikeway_segments
end