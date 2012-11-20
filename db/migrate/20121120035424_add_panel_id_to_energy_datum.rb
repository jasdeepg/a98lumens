class AddPanelIdToEnergyDatum < ActiveRecord::Migration
  def change
    add_column :energy_data, :panel_id, :integer
  end
end
