class EnergyDatum < ActiveRecord::Base
  attr_accessible :day, :hour, :month, :power, :user_id, :year
  belongs_to :user

  def calculate_emissions_for
  	carbon_conversion = 0.69/1000 #kg C02/Wh
  	
  	self.power*carbon_conversion # Wh * kg C02/Wh
  end
end
