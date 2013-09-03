require "open-uri"
require "rexml/document"

module Api
  
  class Deals
    attr_accessor :deals
    
    def initialize(partner, address)
      @partner = partner
      @uri = URI.parse("#{partner.url}?r=#{partner.key}&location=#{address.city.gsub " ", "+"}")
      @deals = []
    end
  
    def get_raw_data
      
      response = @uri.open
      raise "web service error" if response.status.first != "200"
      
      @deals = response.read
      
    end
    
    def get_deals
      
      begin
        response = @uri.open
      rescue
        puts "404 - " + @partner.name
      end
      
      if !response.nil? && response.status.first == "200"
        
        xml_doc = REXML.validate_and_parse response.read
        if xml_doc != false && !xml_doc.elements.nil?
          
          xml_doc.elements.each("*/channel/item") do | deal |
            
            begin
              
              if @deals.find_all { |d| d[:imageUrl] == deal.elements["img"].text }.length == 0
              
              locations = []
              l = {
                :neighborhood => "",
                :address1 => deal.elements["address"].text,
                :address2 => "",
                :city =>  deal.elements["city"].text,
                :state =>  deal.elements["State"].text,
                :zip => deal.elements["zip_code"].text,
                :country => "",
                :phone => deal.elements["phone"].text,
                :longitude => deal.elements["longitude"].text,
                :latitude => deal.elements["latitude"].text
              }
              locations.push l
                
              category = PartnerCategory.get_category deal.elements["category"].text
              
              price = ( deal.elements["sale_price"].text.to_f * 100 ) || 0
              if deal.elements["orig_price"].text.to_f > 0
                value = deal.elements["orig_price"].text.to_f * 100
                discountAmount = value - price
                discountPercent = ( 100 - ( price / value * 100 ) ).round
              else
                value = 0
                discountAmount = 0
                discountPercent = 0
              end
              
              d = {
                
                :partner => @partner.name,
                :partner_id => @partner.id,
                :id => "yourbestdeals-" + deal.elements["deal_id"].text,
                :title => deal.elements["title"].text,
                
                :imageUrl => deal.elements["img"].text,
                :dealUrl => deal.elements["link"].text,
                :pitchHtml => deal.elements["shortdesc"].text,
                :highlightsHtml => deal.elements["restrictions"].text,
                :description => deal.elements["description"].text,
                
                :sold => 0,
                :begin => Time.parse(deal.elements["pubDate"].text || Time.now.to_s).to_s,
                :end => Time.parse(deal.elements["deal_enddate"].text || Time.now.to_s).to_s,
                :remaining => ((Time.parse(deal.elements["deal_enddate"].text || Time.now.to_s) - Time.now)/86400).to_i,
                
                :price => price,
                :value => value,
                :discountAmount => discountAmount,
                :discountPercent => discountPercent,
                  
                :categoryId => category.id,
                :category => category.name,
                
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