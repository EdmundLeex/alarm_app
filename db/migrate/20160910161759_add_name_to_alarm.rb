class AddNameToAlarm < ActiveRecord::Migration
  def change
    add_column :alarms, :name, :string
  end
end
