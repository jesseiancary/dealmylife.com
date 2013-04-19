# encoding: utf-8
require "net/http"
require "feedzirra"

#
# Module must be named "Api"
#
module Api
  #
  # Class must be named "Deals"
  # 
  # Below functions are all required, feel free to add any other functions you need.
  #
  class Deals
    attr_accessor :url, :deals
    
    #
    # REQUIRED
    #
    def initialize(partner, address)
      #
      # Here you will need to figure out if/how to get results based on location.
      # The "address" parameter contains: street1, city, state, zip, lat, lng
      # "lat" and "lng" should always have values.  Let me know if you need "city" to always have a value
      #
      @partner = partner
      @url = URI.parse("#{partner.url}?rid=#{partner.key}") # This currently returns ALL deals
      @raw_data = ""
      @deals = []
    end
    
    #
    # Use this function to get the raw data and display it in the browser.
    # To execute this function instead of "get_deals", add ?test=true to the url in your browser.
    # For example, navigate to: http://dev.dealmylife.com/partners/2/?test=true
    #
    # REQUIRED
    #
    def get_raw_data
        @raw_data = Feedzirra::Feed.fetch_and_parse("#{@url}").sanitize_entries!
    end
    
    #
    # REQUIRED
    #
    def get_deals
      feed = Feedzirra::Feed.fetch_and_parse("#{@url}").sanitize_entries!

        feed.entries.each_with_index do | entry, i |
          
          #
          # "tags" are essentially "categories".  If Eversave lists any type of category, or list of categories, save them to this array.
          #
          tags = Array.new
          t = { :name => "" }
          tags.push t
          
          #
          # Some of the Partners list multiple locations for the same Deal, so "locations" must be an array.
          # Check out "essave:merchantLocation", you will need to loop over these entries for each Deal, and fill in the "locations" array.
          #
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
            
          #
          # All of the elements in the following data structure need to have values, even if the value is an empty string or 0.
          # Try to match the returned data fields to fields in this data structure as close as possible.
          # Some elements in this data structure may not exist in the returned data, just set those fields to either "" or 0.
          # All interfaces must build this data structure identically.
          # If you have a more efficient/ellegant way of populating this data structrue, feel free!
          #
          d = {
            :partner => @partner.name,
            :partner_id => @partner.id,
            :id => "eversave-#{i}", # The "id" is arbitrary, but must begin with the name of the Partner, and must be unique.  Some Partners will return an "id" for each Deal, see groupon.rb.
            :title => entry.title, # This is the only value I have filled in so far, you will need to fill in the rest.
            
            :imageUrl => "",
            :dealUrl => "",
            :pitchHtml => "",
            :highlightsHtml => "",
            :description => "",
            
            :sold => 0,
            :begin => "",
            :end => "",
            :remaining => 0,
            
            :price => 100,
            :value => 200,
            :discountAmount => 100,
            :discountPercent => 50,
            
            :tags => tags,
            :locations => locations
          }
          @deals.push d
          
        end

    end
 
  end
end