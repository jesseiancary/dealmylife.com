class Partner < ActiveRecord::Base
  
  validates_uniqueness_of :name, :case_sensitive => false
  
  has_many :partner_categories, :dependent => :destroy
  has_many :categories, :through => :partner_categories
  
  def file
    SystemFile.new( File.join("lib", "assets", "partners"), name.downcase + ".rb" )
  end
  
  def get_deals ( address )
    load "#{Rails.root}/lib/assets/partners/" + name.downcase.gsub(" ", "-") + ".rb"
    #extend Api
    
    a = Api::Deals.new(self, address)
    a.get_deals
    return a.deals
    
    #return Api.get_deals(url, key, address)
  end
  
  def get_raw_data ( address )
    load "#{Rails.root}/lib/assets/partners/" + name.downcase.gsub(" ", "-") + ".rb"
    #extend Api
    
    a = Api::Deals.new(self, address)
    a.get_raw_data
    return a.deals
    
    #return Api.get_raw_data(url, key, address)
  end
  
end

module JSON
  def self.validate_and_parse json_
    return JSON.parse json_
  rescue JSON::ParserError  
    return false  
  end
end

module REXML
  def self.validate_and_parse xml_
    return REXML::Document.new xml_
  rescue REXML::ParseException  
    return false  
  end
end