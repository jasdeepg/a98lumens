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
#

class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, 
         :rememberable, :trackable, :validatable
  attr_accessible :name, :email, :password, :location, :password_confirmation, 
                  :remember_me, :created_at, :panel_zip
  has_many :energy_data, :class_name => "EnergyDatum", :foreign_key => "user_id"

  ###################
  # Performance data
  ###################
  def monthSum
    t = Time.new

  	last_entry = self.energy_data.where("month=#{t.month} and day=#{t.day}").last
    puts "LASTMONTH", last_entry
    months = (1..last_entry.month).to_a
    days = (1..last_entry.day).to_a
  	@monthTotals = Array.new

  	months.each do |curMonth|
      if curMonth == last_entry.month
        @monthTotals[curMonth-1] = [Time.utc(2012,curMonth).to_i*1000, self.energy_data.where(:month => curMonth, :day => 1..last_entry.day).sum("power")]
      else
    		@monthTotals[curMonth-1] = [Time.utc(2012,curMonth).to_i*1000, self.energy_data.where("month=#{curMonth}").sum("power")]
  	  end
    end

  	return @monthTotals
  end

  # return array with week attributes for graph
  def consolidate_week 
  	#grab last 7 days
    t = Time.new

  	refEntry = self.energy_data.where(:month => t.month, :day => t.day).last
  	refDay = refEntry.day
  	refMonth = refEntry.month
  	count = (0..6).to_a
  	@dateCount = Array.new
  	@weekTotals = Array.new
  	subCount = 0

    #creating date array for weekTotals, assumes each month has 31 days
  	count.each do |var|
  		if (refDay - subCount) > 0
  			@dateCount << [refDay - subCount, refMonth]
  		else
        refDay = 31
  			refMonth = refMonth - 1
  			subCount = 0
  			@dateCount << [refDay - subCount, refMonth]
  		end
  		subCount = subCount + 1
  	end

  	arrayCount = 0

  	@dateCount.each do |day, month|
      temp_Obj = self.energy_data.where(:day=>day, :month=>month).last
  		@weekTotals[arrayCount] = [Time.utc(temp_Obj.year, temp_Obj.month, temp_Obj.day).to_i*1000, self.energy_data.where("day=#{day} AND month=#{month}").sum("power")]
  		arrayCount = arrayCount + 1
  	end

    # return both because @weekTotals must be 0-indexed, @dateCount has actual dates
  	return @dateCount, @weekTotals
  end

  # return array with day attributes for graph
  def consolidate_day
    t = Time.new

    refDay = self.energy_data.where(:day => t.day).select("day").last
    refDay = refDay.day
    refMonth = self.energy_data.where(:month => t.month).select("month").last
    refMonth = refMonth.month
    refYear = self.energy_data.where(:year => t.year).select("year").last
    refYear = refYear.year
    dayofInterest = self.energy_data.where(:year => t.year, :month => t.month, :day => t.day, :hour => (1..(t.hour)))
    @dayTotals = Array.new
    count = 0

    # create array with [hour, power]
    dayofInterest.each do |day|
      @dayTotals[count] = [Time.utc(day.year,day.month,day.day,day.hour).to_i*1000, day.power]
      count = count + 1
    end

    @dayTotals
  end

  #calculate overall power generated
  def calculate_overall_power_for
    t = Time.new

  	self.energy_data.where(:year=>t.year, :month=> (1..(t.month))).sum("power") # total in Wh
  end

  #calculate this week's power
  def calculate_week_power_for
    dates, totals = consolidate_week

    weekPowerCount = 0

    totals.each do |index, total|
      weekPowerCount+=total
    end

    weekPowerCount
  end

  #calculate today's power
  def calculate_day_power_for
    t = Time.new

    self.energy_data.where(:year=>t.year, :month=> t.month, :day=>t.day).sum("power") # total in Wh
  end

  ###################
  #  Constructor
    
  def genericConstructorGreen(tempArray)
    @returnArray = Array.new
    count = 0

    if tempArray.nil?
      tempArray = [1,1]
    end

    tempArray.each do |entry|
      @returnArray[count] = [entry[0], calculate_emissions_for(entry[1])]
      count = count + 1
    end

    @returnArray
  end

  def genericConstructorFinance(tempArray)
    @returnArray = Array.new
    count = 0

    if tempArray.nil?
      tempArray = [1,1]
    end

    tempArray.each do |entry|
      @returnArray[count] = [entry[0], calculate_money_for(entry[1])]
      count = count + 1
    end

    @returnArray
  end

  ###################
  # Green data
  ###################

  def em_monthTotals
    genericConstructorGreen(@monthTotals)
  end

  def em_weekTotals
    genericConstructorGreen(@weekTotals)
  end

  def em_dayTotals
    genericConstructorGreen(@dayTotals)
  end

  #calculate overall carbon emissions saved
  def calculate_emissions_for(powerGenerated)
  	emissionsConversion = 0.00069 #kg C02/Wh

  	powerGenerated*emissionsConversion #Wh * kg C02/Wh
  end

  def calculate_overall_emissions_for
    powerGenerated = calculate_overall_power_for

    calculate_emissions_for(powerGenerated)
  end

  def calculate_overall_trees_for
    treesConversion = 0.08 #trees/kgC02
    amountC02 = calculate_overall_emissions_for

    treesConversion*amountC02 #trees saved overall
  end

  def calculate_overall_cars_for
    carConversion = (5.1*1000) #kg C02/year
    amountC02 = calculate_overall_emissions_for

    amountC02/carConversion #number of cars taken off road this _year_
  end


  ###################
  # Finance data
  ###################

  #calculate overall carbon emissions saved
  def calculate_money_for(powerGenerated)
    moneyConversion = 0.126/1000 # 0.126 cents per kWh -- 0.000126 cents per Wh

    powerGenerated*moneyConversion 
  end

  def calculate_overall_money_for
    powerGenerated = calculate_overall_power_for

    calculate_money_for(powerGenerated)
  end

  def fi_monthTotals
    genericConstructorFinance(@monthTotals)
  end

  def fi_weekTotals
    genericConstructorFinance(@weekTotals)
  end

  def fi_dayTotals
    genericConstructorFinance(@dayTotals)
  end

end
