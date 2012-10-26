class UsersController < ApplicationController
  # before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :show] 
  # before_filter :correct_user, only: [:edit, :update]
  # before_filter :admin_user, only: :destroy

  # def index
    
  #   @user = current_user
  #   @users = (current_user.blank? ? User.all : User.find(:all, :conditions => ["id != ?", current_user.id]))
  #   @fb_users = []
  #   if @user.facebook_access_token
  #     fb_response = HTTParty.get("https://graph.facebook.com/me/friends?access_token="+@user.facebook_access_token)
  #     if fb_response.code == 200
  #       @fb_users = ActiveSupport::JSON.decode(fb_response.body)["data"]
  #     end
  #   end
    

    
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: @users }
  #   end
  # end

  # def show    
  #   @user = User.find(params[:id])
  #   # @microposts = @user.microposts.all(limit:15)
  #   #@feed_items = @microposts
  #   #@micropost = Micropost.new
  #   @gifts = Gift.get_user_activity(@user)
    
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: @user }
  #   end
  # end

  # def new    
  #   @user = User.new
  #   @users = User.where( admin: true)

  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @user }
  #   end
  # end

  # def edit
    
  #   @user = User.find(params[:id])
  # end

  # def create
  #   @user = User.new(params[:user])
    
  #   if @user.save
  #     sign_in @user
  #     flash[:notice] = "Welcome to #{PAGE_NAME}!"
  #     redirect_back_or @user
  #   else
  #     render 'new'
  #   end
  # end

  # def update
  #   msg = ""
  #   puts "#{params}"
  #   @user = User.find(params[:id])
  #   action = params[:commit] == 'Submit Server Code' ? 'servercode' : 'edit'

  #   respond_to do |format|
  #     if @user.update_attributes(params[:user])
  #       sign_in @user
  #       format.html { redirect_to @user, notice: "Update Successful. #{msg}" }
  #       format.json { head :no_content }
  #     else
  #       sign_in @user
  #       format.html { render action: action, notice: "Update Unsuccessful"}
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  
  # def crop
  #   @user = User.find(params[:id])
  # end

  # def destroy
  #   @user = User.find(params[:id])
  #   @user.destroy

  #   respond_to do |format|
  #     format.html { redirect_to users_path, notice: "User Destroyed." }
  #     format.json { head :no_content }
  #   end
  # end
  
  # def following
  #   @title = "Following"
  #   @user = User.find(params[:id])
  #   @users = @user.followed_users
  #   render 'show_follow'
  # end
  
  # def followers
  #   @title = "Followers"
  #   @user = User.find(params[:id])
  #   @users = @user.followers
  #   render 'show_follow'
  # end
  
  # def servercode
  #   @user = current_user
  # end
  
  # private

    
  #   def correct_user
  #     @user = User.find(params[:id])
  #     redirect_to(users_path) unless current_user?(@user)
  #   end
    
  #   def admin_user
  #     redirect_to(users_path) unless current_user.admin?
  #   end
    
  #   def sanitize_filename(file_name)
  #     just_filename = File.basename(file_name)
  #     just_filename.sub(/[^\w\.\-]/,'_')
  #   end
end
