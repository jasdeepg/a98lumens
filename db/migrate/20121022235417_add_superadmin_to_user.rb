class AddSuperadminToUser < ActiveRecord::Migration
 def up
    add_column :users, :superadmin, :boolean, 
                                    :null => false, 
                                    :default => false 
  end

  def down
    remove_column :users, :superadmin
    User.find_by_email('default@example.com').try(:delete)
  end
end
