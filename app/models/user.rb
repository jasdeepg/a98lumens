class User < ActiveRecord::Base
  attr_accessible :email, :name
  has_many :energy_data, :class_name => "EnergyDatum", :foreign_key => "user_id"
  
  def monthSum
  	months = (1..12).to_a
  	@monthsTotal = Array.new

  	months.each do |curMonth|
  		@monthsTotal[curMonth-1] = [curMonth, self.energy_data.where("month=#{curMonth}").sum("power")]
  	end

  	return @monthsTotal
  end

  # return array with day attributes for graph
  def consolidate_day
  	refDay = self.energy_data.select("day").last
  	refDay = refDay.day
  	refMonth = self.energy_data.select("month").last
  	refMonth = refMonth.month
  	refYear = self.energy_data.select("year").last
  	refYear = refYear.year
  	dayofInterest = self.energy_data.where("day=#{refDay} AND month=#{refMonth} AND year=#{refYear}").select("hour, power")
  	dayArray = Array.new
  	count = 0

  	# create array with [hour, power]
  	dayofInterest.each do |day|
  		dayArray[count] = [day.hour, day.power]
  		count = count + 1
  	end

  	return dayArray
  end

  # return array with week attributes for graph
  def consolidate_week 
  	#grab last 7 days
  	refDay = self.energy_data.select("day").last
  	refDay = refDay.day
  	refMonth = self.energy_data.select("month").last
  	refMonth = refMonth.month
  	count = (0..6).to_a
  	@dateCount = Array.new
  	@daySum = Array.new
  	subCount = 0

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
  		@daySum[arrayCount] = [arrayCount, self.energy_data.where("day=#{day} AND month=#{month}").sum("power")]
  		arrayCount = arrayCount + 1
  	end

  	return @dateCount, @daySum
  end

  #calculate overall power generated
  def calculate_overall_power_for
  	self.energy_data.sum("power")
  end

  #calculate overall carbon emissions saved
  def calculate_overall_emissions_for
  	powerGenerated = calculate_overall_power_for
  	emissionsConversion = 0.69/1000 #kg C02/Wh

  	powerGenerated*emissionsConversion #Wh * kg C02/Wh
  end



end
