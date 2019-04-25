class AddBasicInfoToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :basic_time, :datetime, default: Time.zone.parse("2019/04/24 07:30")
    add_column :users, :work_time,  :datetime, default: Time.zone.parse("2019/04/24 08:00")
  end
end
