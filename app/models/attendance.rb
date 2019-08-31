class Attendance < ApplicationRecord
  belongs_to :user
 
  validates :worked_on, presence: true
  
  # 出勤時間が存在しない場合、退勤時間は無効 　追加機能No.7
  validate :finished_at_is_invalid_without_a_started_at
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効  追加機能No.8
  validate :started_at_than_finished_at_fast_if_invalid
  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "を入力してください") if started_at.blank? && finished_at.present?
  end
  
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      errors.add(:started_at,"より退勤時間の方が早くなっています") if started_at > finished_at
    end 
  end  
end