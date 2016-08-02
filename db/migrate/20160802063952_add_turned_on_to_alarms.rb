class AddTurnedOnToAlarms < ActiveRecord::Migration
  def change
    add_column :alarms, :turned_on, :bool, default: false, null: false
  end
end
