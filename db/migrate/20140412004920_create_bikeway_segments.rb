class CreateBikewaySegments < ActiveRecord::Migration
  def change
    create_table :bikeway_segments do |t|
      t.integer :city_rid
      t.integer :city_geo_id
      t.integer :city_linear_feature_name_id
      t.integer :city_object_id
      t.string :full_street_name
      t.string :address_left
      t.string :address_right
      t.string :odd_even_flag_left
      t.string :odd_even_flag_right
      t.integer :lowest_address_left
      t.integer :lowest_address_right
      t.integer :highest_address_left
      t.integer :highest_address_right
      t.integer :from_intersection_id
      t.integer :to_intersection_id
      t.string :street_classification
      t.string :bikeway_type
      t.geometry :geom, :srid => 2019

      t.timestamps
    end
  end
end
