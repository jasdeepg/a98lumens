# == Schema Information
#
# Table name: panels
#
#  id             :integer          not null, primary key
#  power          :float
#  code           :string(255)
#  date_purchased :integer
#  date_online    :integer
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  panel_ref      :integer
#  panel_num     :integer
#

class Panel < ActiveRecord::Base
  # code includes location, field, etc.
  attr_accessible :code, :date_online, :date_purchased, :power, :user_id, :panel_num
  has_many :energy_data, :class_name => "EnergyDatum", :foreign_key => "panel_id", :primary_key => "panel_num"
  belongs_to :user

  ###################
  # Misc
  ###################

  def last_day_power
    @weekTotals.last
  end

  def name
    "Panel " + self.panel_num.to_s
  end

  ###################
  # Performance data
  ###################
  def monthSum
    t = Time.zone.local(2012,12,10);

  	last_entry = self.energy_data.where("month=#{t.month} and day=#{t.day}").last
    #puts "LASTMONTH", last_entry
    months = (1..last_entry.month).to_a
    days = (1..last_entry.day).to_a
  	@monthTotals = Array.new

  	months.each do |curMonth|
      if curMonth == last_entry.month
        @monthTotals[curMonth-1] = [Time.utc(2012,curMonth).to_i*1000, self.energy_data.where(:month => curMonth, :day => 1..last_entry.day).sum("power")/1000]
      else
    		@monthTotals[curMonth-1] = [Time.utc(2012,curMonth).to_i*1000, self.energy_data.where("month=#{curMonth}").sum("power")/1000]
  	  end
    end

  	return @monthTotals
  end

  # return array with week attributes for graph
  def consolidate_week 
  	#grab last 30 days
    t = Time.zone.local(2012,12,10);

  	refEntry = self.energy_data.where(:month => t.month, :day => t.day).last
  	puts "REFENTRY", refEntry.nil?
    refDay = refEntry.day
    puts "PASTDAY"
    tmp_refDay = refDay
  	refMonth = refEntry.month
  	count = (0..30).to_a
  	@dateCount = Array.new
  	@weekTotals = Array.new
  	subCount = 0

    #creating date array for weekTotals, assumes each month has 31 days
  	count.each do |var|
  		if (tmp_refDay - subCount) > 0
  			@dateCount << [tmp_refDay - subCount, refMonth]
  		else
      tmp_refDay = 30
  			refMonth = refMonth - 1
  			subCount = 0
  			@dateCount << [tmp_refDay - subCount, refMonth]
  		end
  		subCount = subCount + 1
  	end

  	arrayCount = 0

  	@dateCount.each do |day, month|
      puts day, " ", month
      temp_Obj = self.energy_data.where(:day=>day, :month=>month).last
  		if month== t.month && day == t.day
        @weekTotals[arrayCount] = [Time.utc(2012, temp_Obj.month, temp_Obj.day).to_i*1000, self.energy_data.where(:day => day, :month => month, :hour=>(1..t.hour)).sum("power")/1000]
      else
        @weekTotals[arrayCount] = [Time.utc(2012, temp_Obj.month, temp_Obj.day).to_i*1000, self.energy_data.where("day=#{day} AND month=#{month}").sum("power")/1000]
  		end
      arrayCount = arrayCount + 1
  	end

    # return both because @weekTotals must be 0-indexed, @dateCount has actual dates
  	return @dateCount, @weekTotals
  end

  # return array with day attributes for graph
  def consolidate_day
    t = Time.zone.local(2012,12,10);

    two_days_ago = t - 2.days
    one_days_ago = t - 1.day

    last_couple_days = self.energy_data.where(:year => t.year, :month => t.month, :day => one_days_ago.day) #we're 1-indexed
    dayofInterest = self.energy_data.where(:year => t.year, :month => t.month, :day => t.day, :hour => (1..(t.hour+1))) #we're 1-indexed
    @dayTotals = Array.new
    count = 0

    hour_sim = 0

    #previous couple days
    last_couple_days.each do |day|
      @dayTotals[count] = [Time.utc(day.year,day.month,day.day,day.hour).to_i*1000, day.power]
      count = count + 1
    end

    # create array with [hour, power]
    dayofInterest.each do |day|
      last_hour = day.hour
      @dayTotals[count] = [Time.utc(day.year,day.month,day.day,day.hour).to_i*1000, day.power]
      count = count + 1
    end

    @dayTotals
  end

  #calculate overall power generated
  def calculate_overall_power_for
    t = Time.zone.now

    until_today = self.energy_data.where(:year=>t.year, :month=> (1..(t.month)), :day=>(1..t.day-1)).sum("power") # total in Wh
    today = self.energy_data.where(:year=>t.year, :month=>t.month, :day=>t.day, :hour=>(1..t.hour)).sum("power") # total in Wh
    until_today + today
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
    t = Time.zone.now

    self.energy_data.where(:year=>t.year, :month=> t.month, :day=>t.day).sum("power") # total in Wh
  end

  ###################
  #  Constructor
  ###################
    
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
    # 1 lb = 0.453592 kg
    # average car mileage (US) is ~12000 miles/year
    # 350g CO2/mile (wikipedia -- http://en.wikipedia.org/wiki/Environmental_impact_of_transport#Cars)
    # 4200 kg C02 per year
    carConversion = 4200 #kg C02 per year
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
