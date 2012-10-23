class AddLocationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :Location, :string
  end
end
