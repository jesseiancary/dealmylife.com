class Address < ActiveRecord::Base
  
  include GeoKit::Geocoders
  
	#validates_presence_of :street1
	#validates_presence_of :city
	validates_presence_of :state
	#validates_presence_of :zip
	
	validates_length_of :street1,	:maximum => 64
	validates_length_of :street2,	:maximum => 64
	validates_length_of :city,		:maximum => 64
	validates_length_of :zip,		:is => 5, :allow_nil => true
	
	validates_numericality_of :zip
	
	belongs_to :state
	
	has_one :profile_addresses
	has_one :profiles, :through => :profile_addresses
  
  def geocode address = ""
    if address.length > 0
      geo_address = MultiGeocoder.geocode address
    elsif !(norm_address = self.to_s).nil?
      geo_address = MultiGeocoder.geocode norm_address
    end
    if geo_address.success.to_s == "true"
      self.street1 = geo_address.street_address || ""
      self.street2 = ""
      self.city = geo_address.city || ""
      self.state = State.find_by_abbr geo_address.state
      self.zip = geo_address.zip || ""
      self.lat = geo_address.lat || ""
      self.lng = geo_address.lng || ""
      return self
    end
    return nil
  end
  
  def to_s
    address = ""
    unless self.state.nil?
      address << self.street1
      address << ((" " if !address.empty? && !self.street2.empty?) || "") << self.street2
      address << ((", " if !address.empty?) || "") << self.city
      address << ((", " if !address.empty?) || "") << self.state.abbr
      address << ((" " if !self.zip.empty?) || "") << self.zip
      #address << (" " if !self.lat.nil?) << self.lat.to_s
      #address << (" " if !self.lng.nil?) << self.lng.to_s
    end
    return address
  end
	
end
