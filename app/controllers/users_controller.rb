class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]

  def new
    @user = User.new
  end

  def create
    user_params = params[:user]
    @user = User.new({ :password => user_params[:password],
      :email => user_params[:email] 
    })
    if @user.save
      redirect_to root_path, :notice => 'User successfully added.'
    else
      render :action => 'new'
    end
  end
  
  def edit
    #@user = User.find(params[:id])
    @user = current_user
  end 

  def update
    #@user = User.find(params[:id])
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to root_path, :notice => 'Updated user information successfully.'
    else
      render :action => 'edit'
    end
  end
end