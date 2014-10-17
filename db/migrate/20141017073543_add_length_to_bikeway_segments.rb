class AddLengthToBikewaySegments < ActiveRecord::Migration
  def change
    add_column :bikeway_segments, :length_m, :float
  end
end
