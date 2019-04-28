class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper  
  include AttendancesHelper
  # 全コントローラーの親クラスとなるApplicationコントローラーにこのモジュールを読み込む処理を記述することで、
  # どのコントローラーでもヘルパーモジュールのメソッドが使用できるようになる
end