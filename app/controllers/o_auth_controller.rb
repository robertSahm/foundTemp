class OAuthController < ApplicationController  
  ERROR = {
    fsqdown: "Foursquare appears to be down now. Please try logging in with Foursquare later.", 
    fbdown: "Facebook appears to be down now. Please try logging in with Facebook later.", 
    notauth: "You didn't authorize the app, so we can't log you in. Try connecting again and authorizing the app."
  }

  # The path /facebook/oauth redirects here.
  def loginWithFacebook
    #Error conditions
    if params[:state] != APP_CONFIG[:facebook][:state] || params[:error] || !params[:code]
      return error_and_redirect(params[:error] ? ERROR[:notauth] : ERROR[:fbdown])    #User did not authorize the app OR facebook is down
    end
    
    #If we get here, we assume the states are equal and we have the code parameter
    requrl = "https://graph.facebook.com/oauth/access_token"+
              "?client_id="+APP_CONFIG[:facebook][:key]+
              "&redirect_uri="+APP_CONFIG[:baseUrl]+APP_CONFIG[:facebook][:redirect]+
              "&client_secret="+APP_CONFIG[:facebook][:secret]+
              "&code="+params[:code]
    athash = get_access_token_for_service_and_url("facebook",requrl)
    return error_and_redirect(ERROR[:fbdown]) if athash["error"]
    
    #Now we need to request Facebook for the user information.
    fbuserresponse = HTTParty.get("https://graph.facebook.com/me?access_token="+athash[:accessToken])
    return error_and_redirect(ERROR[:fbdown]) if fbuserresponse.code != 200       #Bail if we don't get an ok code
 
    #Now we have the user details based on the response
    userdetails    = ActiveSupport::JSON.decode(fbuserresponse.body)
    
    #This will log in by id, email, or create a new user
    deal_with_user_for_service("facebook",userdetails,athash[:accessToken],Time.now+Integer(athash[:expiry]))
  end
  
  # The path /foursquare/oauth redirects here.
  def loginWithFoursquare
    return error_and_redirect(ERROR[:fsqdown]) if !params[:code]
    
    requrl = "https://foursquare.com/oauth2/access_token"+
              "?client_id="+APP_CONFIG[:foursquare][:key]+
              "&client_secret="+APP_CONFIG[:foursquare][:secret]+
              "&grant_type=authorization_code"+
              "&redirect_uri="+APP_CONFIG[:baseUrl]+APP_CONFIG[:foursquare][:redirect]+
              "&code="+params[:code]
    accessToken = get_access_token_for_service_and_url("foursquare",requrl)
    return error_and_redirect(ERROR[:fsqdown]) if accessToken["error"]
    
    #Now we need to fetch the foursquare user credentials
    fsquserresponse = HTTParty.get("https://api.foursquare.com/v2/users/self?v=20120918&oauth_token="+accessToken)
    return error_and_redirect(ERROR[:fbdown]) if fsquserresponse.code != 200       #Bail if we don't get an ok code
    
    #Now we have the user details based on the response
    userdetails = ActiveSupport::JSON.decode(fsquserresponse.body)["response"]["user"]
    
    #This will log in by id, email, or create a new user
    deal_with_user_for_service("foursquare",userdetails,accessToken,nil)
  end
  
  private
    def sign_in_and_redirect(user)
      sign_in user
      return redirect_to '/home'
    end
    
    def error_and_redirect(error)
      flash[:error] = error
      return redirect_to '/'
    end
    
    def get_access_token_for_service_and_url(srv,url)
      tokenresponse = HTTParty.get(url)
      return {"error" => "error"} if tokenresponse.code != 200
      
      if srv    == "facebook"
        fbparts   = tokenresponse.body.split('&')
        return {accessToken: fbparts[0].split('=')[1], expiry: fbparts[1].split('=')[1] }
      elsif srv == "foursquare"
        return ActiveSupport::JSON.decode(tokenresponse.body)["access_token"]
      end
    end
    
    def deal_with_user_for_service(srv,userdetails,accessToken,expiry)
      @existuser = srv == "facebook" ? User.find_by_facebook_id(userdetails["id"]) : User.find_by_foursquare_id(userdetails["id"])
      return sign_in_and_redirect(@existuser) if @existuser       #Log this guy in and call it a day if the user is found by id.
      
      @existuser = User.find_by_email(srv == "facebook" ? userdetails["email"] : userdetails["contact"]["email"])
      if @existuser
        if srv    == "facebook"
          @existuser.facebook_id    = userdetails["id"]
        elsif srv == "foursquare"
          @existuser.foursquare_id  = userdetails["id"]
        end
        @existuser.save
        return sign_in_and_redirect(@existuser)
      end
      #Otherwise, create the user.
      @newuser = nil
      if srv  == "foursquare"
        newuserhash = {
              foursquare_id: userdetails["id"], 
              foursquare_access_token: accessToken, 
              email: userdetails["contact"]["email"], 
              first_name: userdetails["firstName"], 
              last_name: userdetails["lastName"] || " ", 
              photo: userdetails["photo"]["prefix"][0..-2]+userdetails["photo"]["suffix"],
              phone: userdetails["contact"]["phone"], 
              password: "foursquare", 
              password_confirmation: "foursquare" 
              }
      elsif srv == "facebook"
        newuserhash = {
              facebook_id: userdetails["id"], 
              facebook_access_token: accessToken, 
              facebook_expiry: expiry,
              email: userdetails["email"], 
              first_name: userdetails["first_name"], 
              last_name: userdetails["last_name"], 
              photo: "http://graph.facebook.com/"+userdetails["id"]+"/picture", 
              password: "facebook", 
              password_confirmation: "facebook"
              }
      end
      @newuser = User.new(newuserhash)
      @newuser.save!
      sign_in_and_redirect(@newuser)
    end
end
