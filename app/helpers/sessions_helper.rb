module SessionsHelper
  
  # 引数に渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
    #ユーザーのブラウザ内の一時的cookiesに暗号化済みのユーザーIDが自動的に生成  
  end

  # 現在ログイン中のユーザーがいる場合オブジェクトを返す。
  def current_user   
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id]) #@current_user = @current_user || User.find_by(id: session[:user_id])と同じ
    end
  end    #「現在ログインしているユーザー」の値を取得できる

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
     user == current_user
  end   

  # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します。
  def logged_in?
    !current_user.nil?
  end  
  
  # セッションと@current_userを破棄します
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end

  # 記憶しているURL (もしくはデフォルト値) にリダイレクトする(フレンドリーフォワーディング)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end 
  
  # アクセスしようとしたURLを記憶しておく(フレンドリーフォワーディング)
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
