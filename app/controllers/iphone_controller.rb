class IphoneController < AppController

  
  LOGIN_REPLY     = ["id", "photo", "first_name", "last_name" , "address" , "city" , "state" , "zip", "remember_token", "email", "phone", "provider_id"]  
  GIFT_REPLY      = ["giver_id", "giver_name", "item_id", "item_name", "provider_id", "provider_name", "category", "quantity", "message", "created_at", "status", "id"]
  BUY_REPLY       = ["receiver_id", "receiver_name", "item_id", "item_name", "provider_id", "provider_name", "category", "quantity", "message", "created_at", "status", "id"]
  BOARD_REPLY     = ["receiver_id", "receiver_name", "item_id", "item_name", "provider_id", "provider_name", "category", "quantity", "message", "created_at", "status", "giver_id", "giver_name", "id"] 
  PROVIDER_REPLY  = ["receiver_id", "receiver_name", "item_id", "item_name", "provider_id", "provider_name", "category", "quantity", "status", "redeem_id", "redeem_code", "special_instructions", "created_at", "giver_id", "price", "total",  "giver_name", "id"]
  USER_REPLY      = ["id", "photo", "first_name", "last_name", "email", "phone", "facebook_id"]

  
  def create_account
    puts "Create Account"
    puts "#{params}"
    data = params["data"]

    if data.nil?
      message = "Data not received correctly. "
    else
      new_user = create_user_object(data) 
      message = ""          
    end
    
    respond_to do |format|
      if !data.nil? && new_user.save
        response = { "success" => new_user.remember_token }
      else
        message += " Unable to save to database" 
        response = { "error" => message }
      end
      puts response
      format.json { render text: response.to_json }
    end
  end
  
  def login
    puts "Login"
    puts "#{params}"

    response  = {}
    email     = params["email"]
    password  = params["password"]
    
    if email.nil? || password.nil?
      response["error"] = "Data not received."
    else
      user = User.find_by_email(email)     
      if user && user.authenticate(password)
        if user.providers.count == 1
          # get single provider id and send in response hash
          provider_id = user.providers.dup.shift.id
          response["server"] = "#{provider_id}"
        end
        if user.providers.count > 1
          # return multiple to alert app to need for multiple providers page
          response["server"] = "multiple"
        end
        user_json = user.to_json only: LOGIN_REPLY
        response["user"]  = user_json
      else
        response["error"] = "Invalid email/password combination"
      end
    end
    
    respond_to do |format|
      puts response
      format.json { render text: response.to_json }
    end
  end
  
  def gifts
    puts "Gifts"
    puts "#{params}"

    user  = User.find_by_remember_token(params["token"])
    gifts = Gift.get_gifts(user)
    gift_hash = hash_these_gifts(gifts, GIFT_REPLY, true)
  
    respond_to do |format|
      logger.debug gift_hash
      format.json { render text: gift_hash.to_json }
    end
  end

  def buys
    puts "Buys"
    puts "#{params}"

    response = {}
    user                  = User.find_by_remember_token(params["token"])
    gifts, past_gifts     = Gift.get_buy_history(user)
    gift_hash             = hash_these_gifts(gifts, BUY_REPLY, true)
    past_gift_hash        = hash_these_gifts(past_gifts, BUY_REPLY, true)
    response["active"]    = gift_hash
    response["completed"] = past_gift_hash
    
    respond_to do |format|
      #format.json { render json: @gifts, only: GIFT_REPLY }
      logger.debug response
      format.json { render text: response.to_json }
    end
  end
  
  def drinkboard_users
    puts "Drinkboard Users"
    puts "#{params}"

    begin
      user = User.find_by_remember_token(params["token"])
      # @users = User.find(:all, :conditions => ["id != ?", @user.id])
      # providers = Provider.find(:all, :conditions => ["staff_id != ?", nil])
    rescue 
      puts "ALERT - cannot find user from token"
    end
    users    = User.all   
    user_hash = hash_these_users(users, USER_REPLY)
    
    respond_to do |format|
      logger.debug user_hash
      format.json { render text: user_hash.to_json }
    end
  end
  
  def activity
    puts "Activity"
    puts "#{params}"

    @user  = User.find_by_remember_token(params["token"])
    gifts = Gift.get_activity
    gift_hash = hash_these_gifts(gifts, BOARD_REPLY) 
    
    respond_to do |format|
      logger.debug gift_hash
      format.json { render text: gift_hash.to_json }
    end
  end
  
  def provider
    puts "Provider"
    puts "#{params}"

    # @user  = User.find_by_remember_token(params["token"])
    provider = Provider.find(params["provider_id"])
    gifts    = Gift.get_provider(provider)

    gift_hash = hash_these_gifts(gifts, PROVIDER_REPLY) 

    respond_to do |format|
      puts gift_hash
      format.json { render text: gift_hash.to_json }
    end
  end
  
  def locations
    puts "Locations"
    puts "#{params}"

    # @user  = User.find_by_remember_token(params["token"])
    providers = Provider.all
    menus  = {}
    providers.each do |p|
      if p.menu_string
        obj   = ActiveSupport::JSON.decode p.menu_string.data
        x     = obj.keys.pop
        value = obj[x]
        value["sales_tax"]  = p.sales_tax || "7.25"
        menus.merge!(obj)
      end
    end
    respond_to do |format|
      logger.debug menus
      format.json { render text: menus.to_json }
    end
  end
  
  def create_gift 
    puts "Create Gift"
    puts "#{params}"

    response = {}
    message  = ""

    gift_obj = JSON.parse params["gift"]
    if gift_obj.nil?
      message = "No gift data received.  "
      gift    = Gift.new
    else
      gift    = Gift.new(gift_obj)
    end
    
    case params["origin"]
    when 'd'
      #drinkboard - data already received
      response["receiver"]   = "Drinkboard user"
    when 'f'
      # facebook - search users for facebook_id
      if receiver = User.find_by_facebook_id(gift_obj["facebook_id"])
        gift_obj             = add_receiver_to_gift_obj(receiver, gift_obj)
        response["receiver"] = receiver_info_response(receiver)
      else                   
        gift_obj["status"]   = "incomplete"
        response["receiver"] = "NID"
      end
    when 't'
      #twitter - search users for twitter handle
      if receiver = User.find_by_twitter(gift_obj["twitter"])
        gift_obj             = add_receiver_to_gift_obj(receiver, gift_obj)
        response["receiver"] = receiver_info_response(receiver)
      else                   
        gift_obj["status"]   = "incomplete"
        response["receiver"] = "NID"
      end
    when 'c'
      # contacts - search users for phone
      phone_received = gift_obj["receiver_phone"]
      phone = extract_phone_digits(phone_received)
      if receiver = User.find_by_phone(phone)
        gift_obj             = add_receiver_to_gift_obj(receiver, gift_obj)
        response["receiver"] = receiver_info_response(receiver)
      else
        gift_obj["status"]   = "incomplete"
        response["receiver"] = "NID"
      end
    else
      # what to do here ?
      response["error_origin"]   = "No origin indicator sent" 
    end

    begin
      giver           = User.find_by_remember_token(params["token"])
      gift.giver_id   = giver.id
      gift.giver_name = giver.username
    rescue
      message = "Couldn't identify app user. "
    end
    
    response = { "error" => message } if message != "" 
    respond_to do |format|
      if gift.save
        response["success"]       = "Gift received - Thank you!" 
      else
        response["error_server"]  = " Gift unable to process to database." 
      end
      puts response
      format.json { render json: response.to_json }
    end  
  end

  def create_redeem
    puts "Create Redeem"
    puts "#{params}"

    message  = ""
    response = {}
    
    redeem_obj = JSON.parse params["redeem"]
    if redeem_obj.nil?
      message = "data did not transfer. "
      redeem  = Redeem.new
    else
      redeem  = Redeem.new(redeem_obj)
    end
    begin
      receiver = User.find_by_remember_token(params["token"])
    rescue
      message += "Couldn't identify app user. "
    end

    response = { "error" => message } if message != "" 

    respond_to do |format|
      if redeem.save
        response["success"]      = redeem.redeem_code
        response["server_codes"] = redeem.provider.server_to_iphone
      else
        message += " Gift unable to process to database. Please retry later."
        response["error_server"] = message 
      end
      puts response
      format.json { render text: response.to_json}
    end
  end

  def create_order
    puts "Create Order"
    puts "#{params}"

    message   = ""
    response  = {} 
    order_obj = JSON.parse params["data"]
    if order_obj.nil?
      message = "Data not received correctly. "
      order   = Order.new
    else
      order   = Order.new(order_obj)
    end
    begin
      provider_user = User.find_by_remember_token(params["token"])
    rescue
      message      += "Couldn't identify app user. "
    end
    begin
    #   redeem = Redeem.find(order.redeem_id)
    #   redeem_code = redeem.redeem_code
      redeem   = Redeem.find_by_gift_id(order.gift_id)
    rescue
      message += " Could not find redeem code via gift_id. "
    end
    if redeem
      redeem_code = redeem.redeem_code
    else
      redeem_code = "X"
    end
    response = { "error" => message } if message != "" 

    respond_to do |format|
      if order.redeem_code == redeem_code
        if order.save
          response["success"]      = " Sale Confirmed. Thank you!"
        else
          # order.gift.update_attribute(:status, "redeemed")
          response["error_server"] = " Order not processed - database error"
        end
      else
        response["error_server"]   = " the redeem code you entered did not match. "
      end
      puts response
      format.json { render text: response.to_json }
    end  
  end
  
  def update_photo
    puts "Update Photo"
    puts "#{params}"
    response = {}
    begin 
      user  = User.find_by_remember_token(params["token"])
    rescue
      response["error"] = "User not found from remember token"
    end
    
    data_obj = JSON.parse params["data"]
    puts "#{data_obj}"
    
    respond_to do |format|
      if data_obj.nil?
        response["error_iphone"]   = "Photo URL not received correctly from iphone. "
      else
        if user.update_attributes(photo: data_obj["photo"])
          response["success"]      = "Photo Updated - Thank you!"
        else
          response["error_server"] = "Photo URL unable to process to database." 
        end
      end

      puts response
      format.json { render json: response.to_json }
    end
  end
 
  private
  
    def extract_phone_digits(phone_raw)
      if phone_raw
        phone_match = phone_raw.match(VALID_PHONE_REGEX)
        phone       = phone_match[1] + phone_match[2] + phone_match[3]
      end
    end
    
    def receiver_info_response(receiver)
      { "receiver_id" => receiver.id.to_s, "receiver_name" => receiver.username, "receiver_phone" => receiver.phone }
    end
    
    def add_receiver_to_gift_obj(receiver, gift_obj)
      gift_obj["receiver_id"]    = receiver.id
      gift_obj["receiver_name"]  = receiver.username
      gift_obj["receiver_phone"] = receiver.phone
      return gift_obj
    end
  
    def hash_these_users(obj, send_fields)
      user_hash = {}
      index = 1 
      obj.each do |g|
        user_obj = g.serializable_hash only: send_fields
        user_hash["#{index}"] = user_obj.each_key do |key|
          value = user_obj[key]
          user_obj[key] = value.to_s
        end
        index += 1
      end
      return user_hash
    end
  
    def hash_these_gifts(obj, send_fields, address_get=false)
      gift_hash = {}
      index = 1 
      obj.each do |g|
      
        ### >>>>>>>    item_name pluralizer
        # g.item_name = g.item_name.pluralize if g.quantity > 1
        ###  7/27 6:45 UTC
      
        time = g.created_at.to_time
        time_string = time_ago_in_words(time)
      
        gift_obj = g.serializable_hash only: send_fields
        gift_hash["#{index}"] = gift_obj.each_key do |key|
          value = gift_obj[key]
          gift_obj[key] = value.to_s
        end
        
        # add giver photo url 
        giver_user_obj = User.find(g.giver_id)
        gift_obj["giver_photo"] = giver_user_obj.photo.nil? ? "" : giver_user_obj.photo
        
        # add the full provider address
        if address_get
          address = g.provider.address
          city = g.provider.city
          state = g.provider.state
          zip = g.provider.zip
          provider_address_string = "#{address} \n#{city} #{state} #{zip}"
          gift_obj["provider_address"] = provider_address_string
        end
        gift_obj["time_ago"]    = time_string
      
        ### >>>>>>>    this is not stored in gift object
        gift_obj["redeem_code"] = add_redeem_code(g)
        ###  07-27 9:08 UTC
            
        index += 1
      end
      return gift_hash
    end
    
    def add_redeem_code(obj)
      if obj.status == "notified" 
        obj.redeem.redeem_code
      else
        "none"
      end
    end
    
    def create_user_object(data)
      obj = JSON.parse data
      obj.symbolize_keys!
      User.new(obj)
    end

end
