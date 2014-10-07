class Bikeway < ActiveRecord::Base
  has_many :bikeway_segments

  def to_s
    "#{bikeway_name} (pt #{portion}, #{self.bikeway_segments.count} segments)"
  end
end