class AddTurnTimesToRestaurant < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :turn_time_1, :float, default: 1.50
    add_column :restaurants, :turn_time_2, :float, default: 1.75
    add_column :restaurants, :turn_time_3, :float, default: 2.00
    add_column :restaurants, :turn_time_4, :float, default: 2.25
    add_column :restaurants, :turn_time_5, :float, default: 2.50
    add_column :restaurants, :turn_time_6, :float, default: 2.50
    add_column :restaurants, :turn_time_7, :float, default: 2.50
    add_column :restaurants, :turn_time_8, :float, default: 2.50
    add_column :restaurants, :turn_time_9, :float, default: 2.50
    add_column :restaurants, :turn_time_10, :float, default: 2.50
    add_column :restaurants, :turn_time_11, :float, default: 3.00
    add_column :restaurants, :turn_time_12, :float, default: 3.00
    add_column :restaurants, :turn_time_13, :float, default: 3.00
    add_column :restaurants, :turn_time_14, :float, default: 3.00
    add_column :restaurants, :turn_time_15, :float, default: 3.00
    add_column :restaurants, :turn_time_16, :float, default: 3.00
    add_column :restaurants, :turn_time_17, :float, default: 3.00
    add_column :restaurants, :turn_time_18, :float, default: 3.00
    add_column :restaurants, :turn_time_19, :float, default: 3.00
    add_column :restaurants, :turn_time_20, :float, default: 3.00
    remove_column :restaurants, :turn_time, :jsonb, default: {
        1 => 1.25,
        2 => 1.50,
        3 => 1.75,
        4 => 2.00,
        5 => 2.25,
        6 => 2.50,
        7 => 2.50,
        8 => 2.50,
        9 => 2.50,
        10 => 2.50,
        11 => 2.50,
        12 => 3.00,
        13 => 3.00,
        14 => 3.00,
        15 => 3.00,
        16 => 3.00,
        17 => 3.00,
        18 => 3.00,
        19 => 3.00,
        20 => 3.00
    }
  end
end
