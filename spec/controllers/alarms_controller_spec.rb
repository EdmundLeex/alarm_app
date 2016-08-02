# == Schema Information
#
# Table name: alarms
#
#  id         :integer          not null, primary key
#  alarm_time :time             not null
#  days       :string           default([]), is an Array
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  turned_on  :boolean          default(FALSE), not null
#

require 'rails_helper'

RSpec.describe AlarmsController, type: :controller do

end
