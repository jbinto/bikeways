class CreateBikeways < ActiveRecord::Migration
  def change
    create_table :bikeways do |t|
      t.string :bikeway_name
      t.integer :portion
      t.string :description
      t.integer :length_m
      t.integer :bikeway_route_number
    end

    add_reference :bikeway_segments, :bikeway, index: true
  end
end
