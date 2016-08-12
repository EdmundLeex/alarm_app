class AddStatusToAlarms < ActiveRecord::Migration
  def change
    add_column :alarms, :status, :string
  end
end
