class HomeController < ApplicationController
  
  def index
    respond_to do  |format|
      if signed_in?
        @user = current_user
        format.html
      else
        format.html { redirect_to root_path }
      end
    end
  end

  def gift
  
  end
  
  def buy
    @users = User.all
    @providers = Provider.all
    
  end
  
  def drinboard
    
  end
  
  def help 
  end
  
  def contact 
  end

  def about
  end
  
  
  def learn
  end
  
  def news
  end
  



end

