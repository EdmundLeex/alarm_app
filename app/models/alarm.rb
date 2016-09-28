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
#  name       :string
#

class Alarm < ActiveRecord::Base
  include ActiveModel::Dirty
  include OnlineTracker

  ONLINE_MINUTE = 5
  VALID_DAYS = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday].map(&:freeze).freeze
  STATUS = {
    snoozing: 'snooze'.freeze,
    ringing:  'ringing'.freeze,
    stopped:  'stopped'.freeze
  }.freeze

  belongs_to :user

  validates_presence_of  :alarm_time, :user_id
  validates_inclusion_of :turned_on, in: [true, false]
  validates_inclusion_of :status, in: STATUS.values,
                                  allow_blank: true,
                                  message: "status can only be #{STATUS.values}"
  validate :valid_days, :uniq_days

  before_validation      :capitalize_days
  before_save            :convert_time_to_utc, unless: 'alarm_time.utc?'

  def alarm_time
    self[:alarm_time].to_s(:time_with_zone)
  end

  def ring
    fail "Alarm is off." unless turned_on
    return true if ringing?

    go_online
    change_status_to(:ringing)
  end

  def ringing?
    status == STATUS[:ringing]
  end

  def snooze
    return true if snoozing?
    change_status_to(:snoozing)
  end

  def snoozing?
    status == STATUS[:snoozing]
  end

  def stop
    return true if stopped?
    go_offline
    change_status_to(:stopped)
  end

  def stopped?
    status == STATUS[:stopped]
  end

  def alarm_time_to_str
    read_attribute(:alarm_time).to_s(:time)
  end

  private

  def change_status_to(status)
    update_column(:status, STATUS[status])
  end

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

  def capitalize_days
    self.days = [] if days.nil?
    days.map!(&:capitalize)
  end

  def convert_time_to_utc
    self.alarm_time = alarm_time.utc
  end
end
