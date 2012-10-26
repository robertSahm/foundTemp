class Location < ActiveRecord::Base
  attr_accessible :foursquare_id, :foursquare_venue_id, :latitude, :longitude, :provider_id, :user_id
  
  belongs_to :user
  
  def self.allUsersWithinBounds(userIds,bounds)
    Location.find(:all,{ 
      :joins => :user,
      :order => "locations.created_at",
      :conditions => ["locations.latitude >= ? AND locations.latitude <= ? AND locations.longitude >= ? AND locations.longitude <= ? AND locations.user_id IN (?)",bounds[:botLat],bounds[:topLat],bounds[:leftLng],bounds[:rightLng],userIds]
    })
  end
end
