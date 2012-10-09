class EnergyDatum < ActiveRecord::Base
  attr_accessible :day, :hour, :month, :power, :user_id, :year
  belongs_to :user

end
