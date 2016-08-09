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

class AlarmsController < ApplicationController
  before_action :authenticate_user!

  def ring
    @alarm = Alarm.find(params[:id])
    @alarm.go_online

    render json: online_users
  end

  def snooze
    
  end

  def stop
    @alarm = Alarm.find(params[:id])
    segment = params[:segment]

    if segment
      REDIS.srem(segment, @alarm.user_id)
    end
  end

  def create
    @alarm = Alarm.new(alarm_params)

  end

  def destroy
    @alarm = Alarm.find(params[:id])

    @alarm.destroy!
  end

  def update
    @alarm = Alarm.find(params[:id])


  end

  def onlines
    render json: { alarms: Alarm.online_ids }
  end

  private

  def online_users
    # remove this after test
    online_alarm_ids = Alarm.online_ids
    online_users = User.joins(:alarms)
                       .where("alarms.id in (#{online_alarm_ids.join(',')})")
  end
end
