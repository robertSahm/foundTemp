  
  
# database issues    
#FiXES
  # X - status default for gift shold be "open"
  # X - gift should pluralize the drink order @ creation
  # X - gift should save category @ creation
  # X - needs to be a 4 digit precision in the redeem code
  # X - menu_string[:data] should be saved without integers
  # format prices -> add dollar sign && 2 decimal points

# MODELS
  # association between menu_string and menu is off because .menu in menu_strings breaks due to confusion with association
  # has and belongs to many association from items and menu are off

# THOUGHTS
  # 4 the json string has row numbers for iphone when it should just be a menu key with an array of item hashes
  # what happens when somebody buys a drink and there phone number does not produce an app user, either the phone is wrong or changed or the person has yet to set up an account

######################        USERS        ######################

User.delete_all
User.create([
  { email: 'test@test.com', admin: true, password: 'testtest', password_confirmation: 'testtest', first_name: 'Larry', last_name: 'Page' , city: 'New York', state: 'NY', zip: "11238", phone: '1-646-493-4870', address: '1 Google Drive', credit_number: '4444444444444444'},
  { email: 'jb@jb.com', admin: true, password: 'jessjess', password_confirmation: 'jessjess', first_name: 'Jessica', last_name: 'Balzock' , city: 'New York', state: 'NY', zip: "11238", phone: '345-345-3456', address: '1 Google Drive', credit_number: '4444444444444444'},
  {email: 'gj@gj.com', admin: true, password: 'johnjohn', password_confirmation: 'johnjohn', first_name: 'Greg', last_name: 'Johns' , city: 'New York', state: 'NY', zip: "11238", phone: '4564564567', address: '1 Google Drive', credit_number: '4444444444444444'},
  {email: 'fl@fl.com', admin: true, password: 'fredfred', password_confirmation: 'fredfred', first_name: 'Fredrick', last_name: 'Longfellow' , city: 'New York', state: 'NY', zip: "11238", phone: '+1(567)567-5678', address: '1 Google Drive', credit_number: '4444444444444444'},
  {email: 'jp@jp.com', admin: true, password: 'janejane', password_confirmation: 'janejane', first_name: 'Jane', last_name: 'Peppermill' , city: 'New York', state: 'NY', zip: "11238", phone: '6786786789', address: '1 Google Drive', credit_number: '4444444444444444'},
  {email: 'tayloraddison1@gmail.com', admin: true, password: 'drinkb06', password_confirmation: 'drinkb06', first_name: 'Taylor', last_name: 'Addison' , city: 'Tuscaloosa', state: 'AL', zip: "35401", phone: '2052920078', address: '2610 Packberry Lane', credit_number: '2222222222222222'}
])

# put user_ids in Provider
u_id = User.all


######################       PROVIDERS         ######################

Provider.delete_all
Provider.create([
  { name: "Double Down Saloon" , description: "SHUT UP and DRINK", address: "4640 Paradise Rd", city: "Las Vegas", state: "NV", zip: "89169",                   users: [u_id[0]] },
  { name: "Hard Rock Hotel & Casino" , description: "Get a Room", address: "4455 Paradise Road", city: "Las Vegas", state: "NV", zip: "89169",                  users: [u_id[5]] },
  { name: "Hard Rock Hotel & Casino" , description: "Get a Room", address: "207 5th Avenue", city: "San Diego", state: "CA", zip: "92101",                      users: [u_id[1]] },
  { name: "Dos Caminos" , description: "Modern Mexican Food and Tequila Lounge", address: "825 3rd Avenue", city: "New York", state: "NY", zip: "10022",        users: [u_id[2]] },
  { name: "Dos Caminos" , description: "Modern Mexican Food and Tequila Lounge", address: "475 West Broadway", city: "New York", state: "NY", zip: "10012",     users: [u_id[2]] },
  { name: "Dos Caminos" , description: "Modern Mexican Food and Tequila Lounge", address: "675 Hudson Street", city: "New York", state: "NY", zip: "10014",     users: [u_id[2]] },
  { name: "Dos Caminos" , description: "Modern Mexican Food and Tequila Lounge", address: "373 Park Avenue South", city: "New York", state: "NY", zip: "10016", users: [u_id[2]] },
  { name: "Wynn" , description: "Where the Players Play", address: "3131 Las Vegas Blvd. South", city: "Las Vegas", state: "NV", zip: "89109",                  users: [u_id[3]] },
  { name: "Encore" , description: "Upscale Casino", address: "3131 Las Vegas Boulevard South", city: "Las Vegas", state: "NV", zip: "89109",                    users: [u_id[3]] },
  { name: "PT's Pub" , description: "Real. Local. Play.", address: "3935 South Durango Drive ", city: "Las Vegas", state: "NV", zip: "89147",                   users: [u_id[4]] }, 
  { name: "PT's Pub" , description: "Real. Local. Play.", address: "4825 West Flamingo Road # 3", city: "Las Vegas", state: "NV", zip: "89103",                 users: [u_id[4]] },  
  { name: "PT's Pub" , description: "Real. Local. Play.", address: "1661 East Sunset Road", city: "Las Vegas", state: "NV", zip: "89119",                       users: [u_id[4]] },  
  { name: "PT's Pub" , description: "Real. Local. Play.", address: "739 South Rainbow Boulevard", city: "Las Vegas", state: "NV", zip: "89145",                 users: [u_id[4]] }     
])


######################                ITEMS                ######################

# Item db
# "item_name"
# "detail"
# "category" integer
# BEVERAGE_CATEGORIES = ['special'0, 'beer'1, 'wine'2, 'cocktail'3, 'shot'4]

Item.delete_all
Item.create([
  { item_name: "Corona", detail: "Mexican beer", category: 1},
  { item_name: "Budwesier", detail: "American beer", category: 1},
  { item_name: "Fat Tire", detail: "Colorado beer", category: 1},
  { item_name: "Heineken", detail: "Belgian beer", category: 1},
  { item_name: "Stella Artois", detail: "Belgian beer", category: 1},
  { item_name: "Johnny Walker Black", detail: "whiskey", category: 4},
  { item_name: "Johnny Walker Blue",  detail: "whiskey", category: 4},
  { item_name: "Patron", detail: "tequila", category: 4},
  { item_name: "Louis Tre", detail: "tequila", category: 4},
  { item_name: "Jack Daniels",  detail: "whiskey", category: 4},
  { item_name: "Racecar",  detail: "Vodka Redbull", category: 3},
  { item_name: "Painkiller",  detail: "vodka, gin, vermouth, splash of lime", category: 3},
  { item_name: "Martini",  detail: "gin with olives", category: 3},
  { item_name: "Hurricane",  detail: "vodka & fruit juice", category: 3},
  { item_name: "Irish Car Bomb",  detail: "shot of Baileys in a Guiness", category: 3},
  { item_name: "Helpful Dog",  detail: "Merlot", category: 2},
  { item_name: "Saucy Jack",  detail: "Cabernet Sauvignon", category: 2},
  { item_name: "Copolla",  detail: "Cabernet Sauvignon", category: 2},
  { item_name: "Rothschild",  detail: "Pinot Noir", category: 2},
  { item_name: "Fireman's Special",  detail: "Bud with Tabasco", category: 0}
])


######################                MENUS                ######################
# this does not work because menu is only an ITEM WRAPPER

providers = Provider.all
p_id  = providers.map { |p| p.id }
item = Item.all
i_id  = item.map { |i| i.id }

# "provider_id"
# "item_id"
# "price"
# "position"
menu_array = []
# for each provider_id run this loop
p_id.each do |prov_id|
  # for each item_id run this command
  i_id.each do |item_id|
    # make a hash 
      menu_hash = { provider_id: prov_id, item_id: item_id, price: "10"}
    # add hash to the menu_array
      menu_array << menu_hash
  end
end

Menu.delete_all
Menu.create(menu_array)



######################          MENU_STRINGS       #####################
# "version"
# "provider_id"
# "menu_id" 
# "full_address"
# "data"
MenuString.delete_all
p_id.each do |provider|
  menu = Menu.find_all_by_provider_id(provider)
  menu_string = MenuString.new
  menu_string.provider_id = provider
  menu_string.version = 1
  menu_string.full_address = menu_string.provider.full_address
  # make an array of hashes of the items
  full_menu_string = { full_address: menu_string.full_address, 
    location_name: menu_string.provider.name, sales_tax: menu_string.provider.sales_tax }
  num = 1
  menu.each do |m_item|
    item = Item.find(m_item.item_id)
    m_item_hash = { item_id: m_item.item_id.to_s,
       item_name: item.item_name, 
       category: item.category.to_s, 
       detail: item.detail, 
       price: m_item.price}
    full_menu_string[num] = m_item_hash
    num += 1
  end
  string_for_json = Hash[provider, full_menu_string]
  menu_string.data = string_for_json.to_json
  menu_string.save!
end

Gift.delete_all
Redeem.delete_all
Order.delete_all
######################           GIFTS           ######################

#  credit_card          :string(100)
#  redeem_id            :integer
#  status               :string(255)
#  created_at           :datetime        not null
#  updated_at           :datetime        not null

# make 100 gifts
# have 50 of them redeemed
# what about using the created_at to put them in microposts
# make ten gifts , then redeem 5 , have the 5 redeems be random
# keep going till you have redeemed 50
# randomly pick a user to give
# randomly pick a user to receive
# randomly pick a provider
# randomly pick an item
messages = ["Happy Birthday!", "Congratulations!", "One good turn deserves another", "have fun tonight", "Cheers"]
notes = ["Shaken not Stirred", "Draft if you got it", "Fireworks!", "Ice Cold", "Surprise please", "Umbrellas" ]
reply = ["thanks dude your rock!", "yo yo yo get over here", "thats so sweet of you ", "there is a season", "Cheers!", "down the hatch!"] 

users_array     = User.all
users_total     = users_array.count

providers_array = Provider.all
providers_total = providers_array.count

items_array     = Item.all
items_total     = items_array.count

messages_total  = messages.count
notes_total     = notes.count
replies = reply.count

gift_hash = {}

# 2.times do
  5.times do 
    20.times do 
      begin
        receiving_user_index    = rand users_total
        giving_user_index       = rand users_total
      end while receiving_user_index == giving_user_index
      
      giving_user     = users_array[giving_user_index]
      receiving_user  = users_array[receiving_user_index]
  
      provider_index  = rand providers_total 
      provider        = providers_array[provider_index]
  
      item_index      = rand items_total 
      item            = items_array[item_index]   
      menu_item = Menu.find_by_item_id_and_provider_id item, provider
      quantity = rand(5) + 1
      total = menu_item.price.to_i * (quantity + 1)
      item.item_name = item.item_name.pluralize if quantity > 1
      message = "" 
      note = ""
      if quantity < 4 
        message_index = rand messages_total
        message = messages[message_index]
      end
      if giving_user_index < 3  
        notes_index = rand notes_total
        note = notes[notes_index]
      end
      gift_hash = {
        giver_id: giving_user.id, 
        receiver_id: receiving_user.id,
        giver_name: giving_user.username ,
        receiver_name: receiving_user.username,
        provider_name: provider.name,
        item_name: item.item_name,
        provider_id: provider.id, 
        item_id: item.id, 
        price: menu_item.price, 
        quantity: quantity, 
        total: total.to_s,
        message: message, 
        special_instructions: note,
        status: 'open',
        category: item.category.to_s
        }
        # sleep 20
      Gift.create([gift_hash])
    end
    gifts = Gift.where(status: 'open')
    gifts_total = gifts.count
    10.times do 
      index = rand gifts_total
      gift = gifts.slice! index
      gifts_total -= 1
      redeem = Redeem.new
      redeem.gift_id = gift.id
      odds = rand 3
      if odds != 0
        reply_index = rand replies  
        redeem.reply_message = reply[reply_index]
      end
      # redeem.redeem_code = "%04d" % rand(10000)
      if odds != 2  
        notes_index = rand notes_total
        redeem.special_instructions = notes[notes_index]
      end
      # sleep 20
      redeem.save
      redeem.gift.update_attributes({status:'notified'},{redeem_id: redeem.id})
    end
    redeems = Redeem.all
    # find all redeems where the redeem.gift.status == 'notified'
    # find all redeems where the redeem.gift.redeem_id != nil
    redeems_total = redeems.count
    6.times do
       begin
         redeem_index = rand redeems_total
         redeem = redeems.slice! redeem_index
         redeems_total -= 1
       end while redeem.gift.status != 'notified'
       order = Order.new
       order.gift_id = redeem.gift_id
       order.redeem_id = redeem.id
       order.redeem_code = redeem.redeem_code
       # sleep 20
       order.save
       order.gift.update_attribute(:status, "redeemed")
    end
  end
# end



# Provider.find_all_by
#{}" name = 'PT's Pub'"
#{}" zip = '89109'"
#{}"name = 'Dos Caminos'"
# name = = 'Hard Rock Hotel & Casino'
# name = 'Double Down Saloon'


# users = User.all
# users.select! { |u| u.admin == true }
# users.select! { |u| u.first_name != 'Taylor' }
# 
# i = 0
# users.each do |u|
#   case i
#   when 0
#     providers ps = Provider.find_all_by_name("PT's Pub")
#   when 1
#     providers ps = Provider.find_all_by_name("Dos Caminos")
#   when 2
#     providers = Provider.find_all_by_name("Hard Rock Hotel & Casino") 
#   when 3
#     providers = Provider.find_all_by_name("Double Down Saloon")
#   when 4
#     providers = Provider.find_all_by_zip('89109')
#   else
#     providers = []
#   end
#   i += 1
#   # make an array of provider_ids or a single provider_id
#   p_id_array = providers.map { |p| p.id }
#   users[0].update_attributes({provider_id: p_id_array})
  

