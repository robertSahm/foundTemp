users = User.all
providers = Provider.all

# bounds
latitude_top    =  40.81459
latitude_bottom =  40.65851 
longitute_right = -73.78280
longitute_left  = -74.12620

lat  = rand(4078459 - 4067851) * 0.00001 + 40.67851
long = rand(7409620 - 7380280) * 0.00001 + 73.80280

latitude_range = 81459 - 65851


users.each do |u|
  lat  = rand(4078459 - 4067851) * 0.00001 + 40.67851
  long = rand(7409620 - 7380280) * 0.00001 + 73.80280
  Location.create(
    latitude: lat,
    longitude: long,
    user_id: u.id
  )
end

providers.each do |p|
  lat  = rand(4078459 - 4067851) * 0.00001 + 40.67851
  long = rand(7409620 - 7380280) * 0.00001 + 73.80280
  p.latitude  = lat
  p.longitude = long
  p.save
end