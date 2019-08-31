class SessionsController < ApplicationController
 
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # ログインフォームにて入力・送信されたメールアドレスを使って、データベースからユーザーを取得し、userと定義したローカル変数に代入
    if user && user.authenticate(params[:session][:password])
    # ユーザーログイン後にユーザー情報のページにリダイレクトする
    # userオブジェクトがtrueの場合は入力されたメールアドレスを持つユーザーが存在したことになり存在しなければfalseになる
    # authenticateメソッドの引数として入力されたパスワードの値を指定
      log_in user        
      # セッションヘルパー log_in(user)と同じ内容となる
      #params[:session][:remember_me] == '1' ? remember(user) : forget(user)　#チェック#ボックス処理
      redirect_back_or user   
      # Railsで自動的にuser_url(user)に変換され実行される
    else
      flash.now[:danger] = 'メールアドレスとパスワードの情報が一致しませんでした。'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end