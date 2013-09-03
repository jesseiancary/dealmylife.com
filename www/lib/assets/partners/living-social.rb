require "open-uri"
require "json"

module Api
  
  class Deals
    attr_accessor :deals
    
    def initialize(partner, address)
      @partner = partner
      @uri = URI.parse("#{partner.url}deals?api-key=#{partner.key}&coords=#{address.lat.to_s},#{address.lng.to_s}&radius=50")
      @deals = []
    end
  
    def get_raw_data
      
      response = @uri.open
      raise "web service error" if response.status.first != "200"
      
      @deals = JSON.parse response.read
      
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
            
            #begin
              
              option_index = 0
              option_price = 0
              deal["options"].each_with_index do | option, i |
                if option["price"] < option_price || i == 0
                  option_index = i
                end
              end
                
              locations = []
              l = {
                :neighborhood => "",
                :address1 => "",
                :address2 => "",
                :city => "",
                :state => "",
                :zip => "",
                :country => "",
                :phone => "",
                :longitude => "",
                :latitude => ""
              }
              locations.push l
              
              category = PartnerCategory.get_category( if deal["tags"].is_a? Array and deal["tags"].length > 0 then deal["tags"][0]["name"] else "" end )
                
              d = {
                
                :partner => @partner.name,
                :partner_id => @partner.id,
                :id => "livingsocial-" + deal["id"].to_s,
                :title => deal["short_title"],
                
                :imageUrl => deal["images"][0]["size220"],
                :dealUrl => deal["url"],
                :pitchHtml => deal["long_title"],
                :highlightsHtml => "",
                :description => deal["options"][option_index]["description"],
                
                :sold => deal["orders_count"].to_i || 0,
                :begin => Time.parse(deal["offer_starts_at"] || Time.now.to_s).to_s,
                :end => Time.parse(deal["offer_ends_at"] || Time.now.to_s).to_s,
                :remaining => ((Time.parse(deal["offer_ends_at"] || Time.now.to_s) - Time.now)/86400).to_i,
                
                :price => deal["options"][option_index]["price"]*100,
                :value => deal["options"][option_index]["original_price"]*100,
                :discountAmount => deal["options"][option_index]["savings"]*100 || 0,
                :discountPercent => deal["options"][option_index]["discount"] || 0,
                
                :categoryId => category.id,
                :category => category.name,
                
                :locations => locations
                
              }
              @deals.push d
            
            #rescue
            #  puts "Deal Parse Error - " + @partner.name
            #end
            
          end
          
        end
              
      end
      
    end
    
  end
  
end