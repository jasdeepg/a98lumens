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
#  panel_num=     :integer
#

require 'test_helper'

class PanelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
