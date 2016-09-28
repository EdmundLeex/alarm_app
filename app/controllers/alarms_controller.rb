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

class AlarmsController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  # before_action :authenticate_user!, except: :online

  def index
    @alarms = Alarm.all
    render json: @alarms.to_json
  end

  def ring
    @alarm = Alarm.find(params[:id])
    @alarm.ring

    render json: online_users
  end

  def snooze
    @alarm = Alarm.find(params[:id])
    @alarm.snooze
  end

  def stop
    @alarm = Alarm.find(params[:id])
    @alarm.stop
  end

  def create
    binding.pry
    @alarm = Alarm.new(alarm_params)

    if @alarm.save
    else
    end
  end

  def destroy
    @alarm = Alarm.find(params[:id])

    @alarm.destroy!
  end

  def update
    @alarm = Alarm.find(params[:id])


  end

  def online
    render json: { alarms: Alarm.online_ids }
  end

  private

  def alarm_params
    params.require(:alarm).permit(:alarm_time, :name)
  end

  def online_users
    # remove this after test
    online_alarm_ids = Alarm.online_ids
    online_users = User.joins(:alarms)
                       .where("alarms.id in (#{online_alarm_ids.join(',')})")
  end
end
