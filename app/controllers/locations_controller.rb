class LocationsController < ApplicationController
  ##### Location functions are for a specific USER.
  def map
  end
  
  def mapForUserWithinBoundary
    if !required_params ['top_lat', 'bot_lat', 'left_lng', 'right_lng']
      return render json: {error: {errorDesc: "Boundary parameters do not exist in the call."}}
    end
    
    thisUser = getUser
    if !thisUser
      return render json: {error: {errorDesc: "User not found."}}
    end    

    bounds = {botLat: params[:bot_lat], topLat: params[:top_lat], leftLng: params[:left_lng], rightLng: params[:right_lng]}
    
    #All of the provider locations based on the boundary
    @providers = Provider.allWithinBounds(bounds)
    
    #All of the users' following people within the boundary
    
    
    # no followed user implemented yet HACK <<<<<<<
    followedUserIds = User.all.map { |u| u.id }
    ##followedUserIds = User.find(thisUser.id).followed_users.map{ |user| user.id }
    
    @followedUsers = Location.allUsersWithinBounds(followedUserIds, bounds)
    
    #Only render in JSON
    return render json: { providers: @providers, followedUsers: @followedUsers}
  end
  
  def checkinUser
    if !required_params ['lat', 'lng', 'foursquare_id']        #Optional params: provider_id
      return render json: {error: {errorDesc: "Boundary parameters do not exist in the call."}}
    end
    
    thisUser = getUser
    if !thisUser
      return render json: {error: {errorDesc: "User not found."}}
    end    
    
    @user = User.find(thisUser.id)
    if !@user[:foursquare_id]
      return render json: {error: {errorDesc: "User does not have foursquare enabled."}}
    end
    if !@user.checkin_to_foursquare(params[:foursquare_id],params[:lat],params[:lng])
      return render json: {error: {errorDesc: "There was an error checking into foursquare."}}
    end
    
    newLocHash = {:user_id => thisUser.id, :latitude => params[:lat], :longitude => [:lng], :foursquare_venue_id => params[:foursquare_id]}
    newLocHash[:provider_id] = params[:provider_id] if params[:provider_id]
    @newLoc = Location.new(newLocHash)
    
    respond_to do |format|
      format.html #map.html.erb
      format.json {render json: @newLoc}
    end
  end 
  
  def getUser
    if current_user
      return current_user
    elsif !current_user && params["token"]
      return User.find_by_remember_token(params["token"])
    else
      return nil
    end
  end
  ###END Location functions for a specific user
  
  
  
  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end
end
