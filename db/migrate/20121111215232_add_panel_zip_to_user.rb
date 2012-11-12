class AddPanelZipToUser < ActiveRecord::Migration
  def change
    add_column :users, :panel_zip, :string
  end
end
