class CreateEnergyData < ActiveRecord::Migration
  def change
    create_table :energy_data do |t|
      t.integer :month
      t.integer :day
      t.integer :year
      t.integer :hour
      t.float :power
      t.integer :user_id

      t.timestamps
    end
  end
end
