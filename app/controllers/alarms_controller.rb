class AlarmsController < ApplicationController
  def ring
    @alarm = Alarm.find(params[:id])
    segment = params[:segment]

    if segment

    else
      segment = Alarm.segment(Time.now)
      
      REDIS.sadd(segment, @alarm.id)
    end
    user_ids = REDIS.smembers(segment).sample(10)
    users = User.where(id: user_ids)

    render json: users
  end

  def snooze
    
  end

  def stop
    
  end

  def create
    @alarm = Alarm.new

  end

  def destroy
    @alarm = Alarm.find(params[:id])

    @alarm.destroy!
  end

  def update
    @alarm = Alarm.find(params[:id])


  end
end
