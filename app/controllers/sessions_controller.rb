class SessionsController < ApplicationController
  
  def new
    @text = params[:text]
  end
  
  def create
    transfer = false
    if params[:page] == 'development'
      user = User.find_by_email(params[:email])
      case params[:email]
      when 'test@test.com'
        password = 'testtest'
      when 'jb@jb.com'
        password = 'jessjess'
      when 'gj@gj.com'
        password = 'johnjohn'
      when 'fl@fl.com'
        password = 'fredfred'
      when 'jp@jp.com'
        password = 'janejane'
      else
        transfer = true
      end
    else
      user = User.find_by_email(params[:session][:email])
      password = params[:session][:password]
    end
    if user && user.authenticate(password)
      sign_in user
      redirect_to home_path
    else
      flash[:error] = 'Invalid email/password combination' if !transfer
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
  
end













