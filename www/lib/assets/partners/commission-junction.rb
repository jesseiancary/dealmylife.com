require "open-uri"
require "rexml/document"

module Api
  
  class Deals
    attr_accessor :deals
    
    def initialize(partner, address)
      @partner = partner
      @uri = URI.parse("#{partner.url}product-search?website-id=5584358&records-per-page=100&advertiser-ids=joined&keywords=#{URI.encode(address.city)}")
      #@uri = URI.parse("#{partner.url}link-search?website-id=5584358&records-per-page=100&advertiser-ids=joined&keywords=#{URI.encode(address.city)}")
      @deals = []
    end
  
    def get_raw_data
      
      response = @uri.open "authorization" => self.key
      raise "web service error" if response.status.first != "200"
      
      @deals = response.read
      
    end
    
    def get_deals
      
      begin
        response = @uri.open "authorization" => self.key
      rescue
        puts "404 - " + @partner.name
      end
      
      if !response.nil? && response.status.first == "200"
        
        xml_doc = REXML.validate_and_parse response.read
        if xml_doc != false && !xml_doc.elements.nil?
          
          xml_doc.elements.each("*/products/product") do | deal |
            
            begin
              
              if !deal.elements["image-url"].text.nil?
                
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
                
                price = ( deal.elements["price"].text.to_f * 100 ) || 0
                if deal.elements["retail-price"].text.to_f > 0
                  value = ( deal.elements["retail-price"].text.to_f * 100 ) || 0
                  discountAmount = ( deal.elements["retail-price"].text.to_f - price ) * 100
                  discountPercent = ( 100 - ( price / value ) ).round
                else
                  value = 0
                  discountAmount = 0
                  discountPercent = 0
                end
                
                d = {
                  
                  :partner => deal.elements["advertiser-name"].text,
                  :partner_id => @partner.id,
                  :id => deal.elements["advertiser-id"].text + "-" + deal.elements["ad-id"].text,
                  :title => deal.elements["name"].text,
                  
                  :imageUrl => deal.elements["image-url"].text,
                  :dealUrl => deal.elements["buy-url"].text,
                  :pitchHtml => deal.elements["description"].text,
                  :highlightsHtml => "",
                  :description => deal.elements["description"].text,
                  
                  :sold => 0,
                  :begin => Date.today,
                  :end => Date.today,
                  :remaining => 0,
                  
                  :price => price,
                  :value => value,
                  :discountAmount => discountAmount,
                  :discountPercent => discountPercent,
                  
                  :locations => locations
                  
                }
                @deals.push d
                
              end
            
            rescue
              puts "Deal Parse Error - " + @partner.name
            end
            
          end
          
        end
        
=begin
        xml_doc.elements.each("*/links/link") do | deal |
          
          unless deal.elements["link-type"].text == "Text deal"
            
            locations = Array.new
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
            
            d = {
              
              :partner => deal.elements["advertiser-name"].text,
              :id => deal.elements["advertiser-id"].text + "-" + deal.elements["link-id"].text,
              :title => deal.elements["link-name"].text,
              
              :imageUrl => deal.elements["link-code-html"].text[deal.elements["link-code-html"].text.index("img src=")+9..deal.elements["link-code-html"].text.index("\"", deal.elements["link-code-html"].text.index("img src=")+10)-1],
              :dealUrl => deal.elements["link-code-html"].text[deal.elements["link-code-html"].text.index("a href=")+8..deal.elements["link-code-html"].text.index("\"", deal.elements["link-code-html"].text.index("a href=")+9)-1],
              :pitchHtml => deal.elements["description"].text,
              :highlightsHtml => "",
              :description => deal.elements["description"].text,
              
              :soldQty => "",
              :begin => "",
              :end => "",
              :remaining => 0,
              
              :price => 0,
              :value => 0,
              :discountAmount => 0,
              :discountPercent => 0,
              
              :locations => locations
              
            }
            @deals.push d
            
          end
          
        end
=end
        
      end
      
    end
    
  end
  
end