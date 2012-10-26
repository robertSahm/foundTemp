class Employee < ActiveRecord::Base
  attr_accessible :active, :clearance, :provider_id, :user_id
  
  belongs_to :user
  belongs_to :provider
  has_many 	 :orders,    :through => :provider
  
  validates_presence_of :user_id, :provider_id

  def server_code
  	self.user.server_code 	
  end

  def name
  	self.user.username
  end

  def photo
  	self.user.photo
  end

  def servers_hash
    send_fields = [ :id, :first_name, :last_name, :photo, :server_code]
    self.users.map { |e| e.serializable_hash only: send_fields  }
  end

  def servers
    # get the employee_id and user_id 
  # from user record
    # get the full_name 
    # photo url
    # server_code

  end

end
