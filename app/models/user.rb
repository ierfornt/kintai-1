class User < ApplicationRecord
  has_many :attendances, dependent: :destroy  
  #dependent: :destroyというオプションを指定すると、ユーザーが削除された時に、そのユーザーの持つAttendanceモデルのデータも一緒に削除されるようになります。
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true 
  # allow_nil: true 「パスワード（と確認用パスワード）を入力している場合は更新」、「パスワードを入力していない場合は検証をスルーして更新（他の属性の検証は勿論実行される）」
  validates :department, length: { in: 3..50 }, allow_blank: true #空の検証をスキップさせるときに使用する
  
  def self.search(search)  #ここでのself.はUser.を意味する
    if search
      where(['name LIKE ?', "%#{search}%"])  #検索とnameの部分一致を表示。User.は省略
    else 
      all  #全て表示。User.は省略
    end
  end
end