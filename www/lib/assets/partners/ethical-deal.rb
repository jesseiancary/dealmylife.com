require "open-uri"
require "rexml/document"

module Api
  
  class Deals
    attr_accessor :deals
    
    def initialize(partner, address)
      @partner = partner
      #@uri = URI.parse("#{partner.url}all.xml?pid=#{partner.key}")
      @uri = URI.parse("#{partner.url}#{address.city.gsub " ", "-"}.xml?pid=#{partner.key}")
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
          
          xml_doc.elements.each("*/deals/deal") do | deal |
            
            begin
              
              if Time.parse(deal.elements["end_date"].text) > Time.now
                
                #puts ( %r-\d+$/.match("123456789-987") )
=begin        
                option_index = 0
                option_price = 0
                deal["options"].each_with_index do | option, i |
                  if option["price"]["amount"] < option_price || i == 0
                    option_index = i
                  end
                end
=end        
                #puts deal.to_s
                locations = []
                l = {
                  :neighborhood => "",
                  :address1 => "",
                  :address2 => "",
                  :city => deal.elements["division_name"].text || "",
                  :state => "",
                  :zip => "",
                  :country => "",
                  :phone => "",
                  :longitude => "",
                  :latitude => ""
                }
                locations.push l
                
                category = PartnerCategory.get_category deal.elements["deal_subcategory"].text
                
                price = ( deal.elements["price"].text.to_f * 100 ) || 0
                if deal.elements["value"].text.to_f > 0
                  value = deal.elements["value"].text.to_f * 100
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
                  :id => "ethicaldeal-" + deal.elements["id"].text || "",
                  :title => deal.elements["title"].text || "",
                  
                  :imageUrl => "http://ethicaldeal.com" + deal.elements["large_image_url"].text || "",
                  :dealUrl => deal.elements["affiliate_link"].text || "",
                  :pitchHtml => "",
                  :highlightsHtml => "",
                  :description => deal.elements["description"].text || "",
                  
                  :sold => deal.elements["quantity_sold"].text.to_i || 0,
                  :begin => Time.parse(deal.elements["start_date"].text || Date.today.to_s).to_s,
                  :end => Time.parse(deal.elements["end_date"].text || Date.today.to_s).to_s,
                  :remaining => ((Time.parse(deal.elements["end_date"].text || Time.now.to_s) - Time.now)/86400).to_i,
                  
                  :price => price,
                  :value => value,
                  :discountAmount => discountAmount,
                  :discountPercent => discountPercent,
                  #:discountPercent => deal.elements["discount_percent"].text.gsub("%", ""),
                  
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