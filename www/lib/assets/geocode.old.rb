module Geocode
  
  def self.get_location(address)
    
    url = ("http://maps.googleapis.com/maps/api/geocode/json?address=" << address << "&sensor=false").gsub(" ", "+")
    response = Net::HTTP.get_response(URI.parse(url)).body
    
    response = JSON.parse(response)
    if response.has_key? "Error"
       raise "web service error"
    end
    
    location = response["results"][0]["geometry"]["location"]
    
    return location
    
  end
  
end