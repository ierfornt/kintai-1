class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  #ログインしていないユーザーが保護されたページにアクセスした場合、ログインページへ転送し、かつメッセージを添える。
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_referer
  
  def index
    @users = User.paginate(page: params[:page]).search(params[:search])
    #@users = User.all
    
  end
  
  def show
    @user = User.find(params[:id])
    @first_day = first_day(params[:first_day])
    @last_day  = @first_day.end_of_month
    (@first_day..@last_day).each do |day|
      
      unless @user.attendances.any? {|attendance| attendance.worked_on == day}
        record = @user.attendances.build(worked_on: day) #buildメソッド:あるモデルに関連づいたモデルのデータを生成する
        record.save
#@userに紐付いた当月の初日から末日までのattendancesテーブルのレコードがあるか確認,ない場合は該当する日付をworked_onに代入し、保存する」という処理が実行される。
#このany?メソッドは、ブロック変数attendanceに要素を入れながらブロック（ここではattendance.worked_on == day）を実行し、ブロックが真（true）を返した時は、
#ブロック実行をその時点で中断しtrueを返します。ブロックの戻り値が全て偽（false）である時はfalseが返されます。      
      end
    end
    @dates = user_attendances_month_date
    @worked_sum = @dates.where.not(started_at: nil).count #where.not:nil以外を取得, count:条件に合った要素の数だけを取得
  end  
    
  def new
    @user = User.new #新規作成されたUserオブジェクトをインスタンス変数に代入する
  end
  
  def create
    @user = User.new(user_params)
    if @user.save 
       log_in @user  # 保存成功後、ログインします。
       flash[:success] = "ユーザの新規作成に成功しました。"
       redirect_to @user
    else
      render 'new'
    end  
  end
 
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # 更新に成功した場合の処理
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:succerss] = "削除しました。"
    redirect_to users_url
  end 
  
  def edit_basic_info 
    @user = User.find(params[:id])
  end
  
  def update_basic_info
    @user = User.find(params[:id])
    if @user.update_attributes(basic_info_params)
      flash[:success] = "基本情報を更新しました。"
      redirect_to @user
    else
      render 'edit_basic_info'
    end
  end 

  #def basic_info  #特定のユーザーの指定基本時間を表示する
   # @user = User.find_by(id: params[:id])
  #end

 private
 
  def user_params   #Strong Parameters
    params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
  end
end

  def basic_info_params  
    params.require(:user).permit(:basic_time, :work_time)
  end

# beforeアクション

# ログイン済みユーザーか確認
# ログインしていないユーザーが保護されたページにアクセスした場合、ログインページへ転送し、かつメッセージを添える。
  def logged_in_user
    unless logged_in?   # if !logged_in?と同じ
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

# 正しいユーザーかどうか確認,ユーザーが自身の情報のみを編集・更新できるようになる
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end 

# 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def correct_referer  #一般ユーザーが他のユーザーのIDをURLに直接入力禁止　before_action定義
  if request.referer.nil?
    redirect_to root_url
  end
end
