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
#

class Alarm < ActiveRecord::Base
  include ActiveModel::Dirty

  VALID_DAYS = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]

  belongs_to :user

  validates_presence_of :alarm_time, :user_id
  validate :valid_days

  def self.segment(time)
    hh = time.hour
    mm = time.min
    mm = mm - (mm % 5)
    "#{hh}#{mm}"
  end

  def alarm_time_to_str
    read_attribute(:alarm_time).to_s(:time)
  end

  private

  def valid_days
    return if days.blank?
    unless  days.all? { |day| VALID_DAYS.include?(day) }
      errors.add(:days, "#{days} contain invalid day")
    end
  end

  def uniq_days
    unless days.uniq.size == days.size
      errors.add(:days, "days must be unique")
    end
  end
end
