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
  def ring
    @alarm = Alarm.find(params[:id])
    segment = params[:segment]

    unless segment
      segment = Alarm.segment(Time.now)  
      REDIS.sadd(segment, @alarm.user_id)
    end

    user_ids = REDIS.smembers(segment).sample(10)
    users = User.where(id: user_ids)

    render json: users
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
end
