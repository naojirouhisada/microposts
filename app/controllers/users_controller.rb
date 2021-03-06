class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  
  def show #追加
    @user = User.find(params[:id])
    @microposts = @user.microposts
   
  end
  
  def following
    @user = User.find(params[:id])
    @following = @user.following_users
    @following_relationships = @user.following_relationships
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.follower_users
    @follower_relationships = @user.follower_relationships
   end
  
  def new
    @user = User.new
  end
    
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    if @user.update(user_params)
      # 保存に成功した場合はトップページへリダイレクト
      redirect_to root_path , notice: 'Profileを編集しました'
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end
    
  private
    
  def user_params
    params.require(:user).permit(:name,:area, :email, :password,
                                   :password_confirmation)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
end
