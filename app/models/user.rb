class User < ActiveRecord::Base
  attr_accessible :email, :name
  has_many :energy_data, :class_name => "EnergyDatum", :foreign_key => "user_id"
end
