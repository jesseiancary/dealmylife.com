require "open-uri"
require "json"

module Api
  
  class Deals
    attr_accessor :deals
    
    def initialize(partner, address)
      @partner = partner
      @key = partner.key
      @uri = URI.parse("#{partner.url}regions/#{address.city.gsub(" ", "-").downcase}/deals")
      @deals = []
    end
  
    def get_raw_data
      
      response = @uri.open
      raise "web service error" if response.status.first != "200"
      
      @deals = JSON.parse response.read
      
    end
    
    def parse_date(date)
      
      date = date[5..6] +"/"+ date[8..9] +"/"+ date[0..3] if !date.nil?
      
      return date
      
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
              
              if deal["ended"] == false
                
                locations = []
                deal["locations"].each do | location |
                  l = {
                    :neighborhood => location["address"]["locality"],
                    :address1 => location["address"]["street"],
                    :address2 => "",
                    :city => location["address"]["locality"],
                    :state => location["address"]["region"],
                    :zip => location["address"]["postal_code"],
                    :country => location["address"]["country"],
                    :phone => location["phone"],
                    :longitude => location["address"]["longitude"],
                    :latitude => location["address"]["latitude"]
                  }
                  locations.push l
                end
                
                #category = PartnerCategory.get_category "Other"
                
                price = deal["current_price"].to_f || 0
                if deal["value"].to_f > 0
                  value = deal["value"].to_f
                  discountAmount = value - price
                  discountPercent = ( ( price / value ) * 100 ).round
                else
                  value = 0
                  discountAmount = 0
                  discountPercent = 0
                end
                  
                d = {
                  
                  :partner => @partner.name,
                  :partner_id => @partner.id,
                  :id => "homerun-" + deal["deal_id"],
                  :title => deal["title"],
                  
                  :imageUrl => deal["primary_image"]["thumb"]["url"],
                  :dealUrl => deal["purchase_url"] + "?_a=#{@key}",
                  :pitchHtml => deal["description2"],
                  :highlightsHtml => deal["highlights"],
                  :description => deal["description1"],
                  
                  :sold => deal["number_sold"] || 0,
                  :begin => Time.parse(deal["start_at"] || Time.now.to_s).to_s,
                  :end => Time.parse(deal["expires_at"] || Time.now.to_s).to_s,
                  :remaining => ((Time.parse(deal["expires_at"] || Time.now.to_s) - Time.now)/86400).to_i,
                  
                  :price => price,
                  :value => value,
                  :discountAmount => discountAmount,
                  :discountPercent => discountPercent,
                  
                  #:categoryId => category.id,
                  #:category => category.name,
                  
                  :locations => locations
                  
                }
                @deals.push d
                
              end
            
            rescue
              puts "Deal Parse Error - " + @partner.name
            end
            
          end
          
        end
        
      end
      
    end
    
  end
  
end