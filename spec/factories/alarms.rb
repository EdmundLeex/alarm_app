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
#  status     :string
#  online_key :string
#

FactoryGirl.define do
  factory :alarm do
    alarm_time "15:14"
    days %w[Monday Tuesday Friday]
    turned_on true
    user
  end
end
