class AddTurnTimeToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :turn_time, :jsonb, default: {
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
