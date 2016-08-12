class AddOnlineKeyToAlarms < ActiveRecord::Migration
  def change
    add_column :alarms, :online_key, :string
  end
end
