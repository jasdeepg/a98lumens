# == Schema Information
#
# Table name: energy_data
#
#  id         :integer          not null, primary key
#  month      :integer
#  day        :integer
#  year       :integer
#  hour       :integer
#  power      :float
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  panel_id   :integer
#

class EnergyDatum < ActiveRecord::Base
  attr_accessible :day, :hour, :month, :power, :user_id, :year, :panel_id
  belongs_to :panel

  ###################
  # Green data
  ###################

  def calculate_emissions_for
  	carbon_conversion = 0.69/1000 #kg C02/Wh
  	
  	self.power*carbon_conversion # Wh * kg C02/Wh
  end

  def calculate_trees_for
    trees_conversion = 0.08 #trees/kgC02
    kgC02_saved = calculate_emissions_for

    kgC02_saved*trees_conversion # trees produced
  end
  
  ###################
  # Finance data
  ###################

  def calculate_money_for
    cost_per_wh = 0.126/1000 #cost per Wh

    self.power*cost_per_wh #money made per hour
  end


end
