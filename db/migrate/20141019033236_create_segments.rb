class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.string :full_street_name
      t.integer :lowest_address_left
      t.integer :lowest_address_right
      t.integer :highest_address_left
      t.integer :highest_address_right
      t.string :bikeway_type
      t.geometry :geom, :srid => 4326
      t.float :length_m
      t.timestamps
    end
  end
end
