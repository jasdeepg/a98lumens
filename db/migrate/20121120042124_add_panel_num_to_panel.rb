class AddPanelNumToPanel < ActiveRecord::Migration
  def change
    add_column :panels, :panel_num, :integer
  end
end
