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

require 'test_helper'

class EnergyDatumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
