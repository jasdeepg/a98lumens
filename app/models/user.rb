# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  superadmin             :boolean          default(FALSE), not null
#  Location               :string(255)
#  panel_zip              :string(255)
#  state_id               :integer
#

class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, 
         :rememberable, :trackable, :validatable
  attr_accessible :name, :email, :password, :location, :password_confirmation, 
                  :remember_me, :created_at, :panel_zip
  has_many :panels, :foreign_key => "user_id"

end
