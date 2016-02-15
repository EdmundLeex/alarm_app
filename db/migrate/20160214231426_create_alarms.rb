class CreateAlarms < ActiveRecord::Migration
  def change
    create_table :alarms do |t|
      t.time :alarm_time, null: false
      t.string :days, array: true, default: []
      t.references :user, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
