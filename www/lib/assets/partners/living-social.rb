require "open-uri"
require "json"
#require "date"

module Api
  
  class Deals
    attr_accessor :deals
    #protected
    
    def initialize(partner, address)
      @partner = partner
      @uri = URI.parse("#{partner.url}deals?api-key=#{partner.key}&coords=#{address.lat.to_s},#{address.lng.to_s}&radius=50")
      @deals = []
    end
  
    def get_raw_data
      
      response = @uri.open
      raise "web service error" if response.status.first != "200"
      
      return JSON.parse response.read
      
    end
    
    def get_deals
      
      begin
        response = @uri.open
      rescue
        puts "404 - " + @partner.name
      end
      
      if !response.nil? && response.status.first == "200"
        
        response = JSON.validate_and_parse response.read # Generate Ruby Data Structure from JSON response
        if response != false && !response["deals"].nil?
          
          response["deals"].each do | deal |
            
            begin
              
              option_index = 0
              option_price = 0
              deal["options"].each_with_index do | option, i |
                if option["price"]["amount"] < option_price || i == 0
                  option_index = i
                end
              end
              
              locations = []
              deal["options"][option_index]["redemptionLocations"].each do | location |
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
              end
              
              category = PartnerCategory.get_category( if deal["tags"].is_a? Array and deal["tags"].length > 0 then deal["tags"][0]["name"] else "" end )
                
              d = {
                
                :partner => @partner.name,
                :partner_id => @partner.id,
                :id => "groupon-" + deal["id"],
                :title => deal["announcementTitle"],
                
                :imageUrl => deal["sidebarImageUrl"],
                :dealUrl => deal["dealUrl"],
                :pitchHtml => deal["pitchHtml"],
                :highlightsHtml => deal["highlightsHtml"],
                :description => if deal["options"][option_index]["details"].length > 0 then deal["options"][option_index]["details"][0]["description"] else "" end,
                
                :sold => deal["options"][option_index]["soldQuantity"].to_i || 0,
                :begin => Time.parse(deal["tippedAt"] || Time.now.to_s).to_s,
                :end => Time.parse(deal["endAt"] || Time.now.to_s).to_s,
                :remaining => ((Time.parse(deal["endAt"] || Time.now.to_s) - Time.now)/86400).to_i,
                
                :price => deal["options"][option_index]["price"]["amount"],
                :value => deal["options"][option_index]["value"]["amount"],
                :discountAmount => deal["options"][option_index]["discount"]["amount"].to_i || 0,
                :discountPercent => deal["options"][option_index]["discountPercent"].to_i || 0,
                
                :categoryId => category.id,
                :category => category.name,
                
                :locations => locations
                
              }
              @deals.push d
            
            rescue
              puts "Deal Parse Error - " + @partner.name
            end
            
          end
          
        end
              
      end
      
    end
    
  end
  
end