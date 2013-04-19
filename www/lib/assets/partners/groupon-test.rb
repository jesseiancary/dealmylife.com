require "net/http"
require "json/add/rails"

module Api
  protected
  
  def self.get_deals(url, key, address)
    
    url << "deals?client_id=" << key << "&lat=" << address.lat.to_s << "&lng=" << address.lng.to_s << "&radius=10"
    response = Net::HTTP.get_response(URI.parse(url)).body
    
    response = JSON.parse(response) # Generate Ruby Data Structure from JSON response
    if response.has_key? "Error"
       raise "web service error"
    end
    
    deals = Array.new
    
    response["deals"].each { | deal |
      #deals.push
      
      deal["options"].each { | option |
        begin
          
          locations = Array.new
          option["redemptionLocations"].each { | location |
            l = {
              :neighborhood => location["neighborhood"],
              :address1 => location["streetAddress1"],
              :address2 => location["streetAddress2"],
              :city => location["city"],
              :state => location["state"],
              :zip => location["postalCode"],
              :country => location["country"],
              :phone => location["phoneNumber"],
              :longitude => location["lng"],
              :latitude => location["lat"]
            }
            locations.push l
          }
          
          d = {
            
            :partner => "Groupon the Ultimate Test",
            :id => deal["id"] + "-" + option["id"].to_s,
            :title => option["title"],
            
            :imageUrl => deal["sidebarImageUrl"],
            :dealUrl => deal["dealUrl"],
            :pitchHtml => deal["pitchHtml"],
            :highlightsHtml => deal["highlightsHtml"],
            :description => if option["details"].length > 0 then option["details"][0]["description"] end,
            
            :soldQty => option["soldQuantity"],
            :begin => deal["tippedAt"],
            :end => option["expiresAt"],
            
            :price => option["price"]["amount"],
            :value => option["value"]["amount"],
            :discountAmount => option["discount"]["amount"],
            :discountPercent => option["discountPercent"],
            
            :tags => deal["tags"],
            
            :locations => locations
            
          }
          deals.push d
          
        rescue
          raise "groupon parse error"
          print "ERROR--- groupon parse error"
        end
      }
      
    }
    
    return deals
    #return response["deals"][0]
    
  end
  
end