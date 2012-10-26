class AdminsController < ApplicationController

  def hello
    sign_out
  end

  def create
    admin     = params[:admin][:username]
    password  = params[:admin][:password]
    if admin  == "wibble" && password == "drivein"    
      redirect_to home_path
    else
      flash.now[:error] = 'Invalid email/password combination'
      redirect_to root_path
    end
  end
 
  def destroy
    sign_out
    redirect_to root_path
  end



end
