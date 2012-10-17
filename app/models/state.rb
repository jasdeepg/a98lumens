# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  year       :integer
#  month      :integer
#  day        :integer
#  hour       :integer
#  power      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class State < ActiveRecord::Base
  attr_accessible :day, :hour, :month, :power, :year
  has_many :user, :class_name=>"User", :foreign_key => "state_id"

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
end
