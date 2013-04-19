class Profile < ActiveRecord::Base
	attr_protected :user_id
	
	validates_length_of		:first_name,	:maximum => 64
	validates_length_of		:middle_name,	:maximum => 64
	validates_length_of		:last_name,		:maximum => 64
	
	validates_inclusion_of	:birthdate,		:in => DateTime.new(1900)..DateTime.now,	:allow_nil => true,		:message => "Please enter a valid birthdate."
	
	belongs_to :user
	
	has_many	:profile_addresses, :dependent => :destroy
	has_many	:addresses, :through => :profile_addresses, :select => "*", :readonly => false
  
  def get_default_address
    return self.addresses.find_by_default(true)
  end
  
end
