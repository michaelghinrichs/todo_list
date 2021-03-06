class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]

  def new
    if current_user
      redirect_to lists_url
    else
      #redirect_to '/login'
      @user = User.new
    end  
  end

  def create
    user_params = params[:user]
    @user = User.new({ :password => user_params[:password],
      :email => user_params[:email] 
    })
    if @user.save
      redirect_to login_path, :notice => 'User successfully added. Please login with newly created credientials'
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
