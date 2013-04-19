class PartnerCategory < ActiveRecord::Base
  belongs_to :partner
  belongs_to :category, :dependent => :destroy
  
  def self.get_category ( c )
    
    category = find_by_partner_category_name( c ).try( :category ) || find_by_partner_category_name( "Other" ).category
    
    return category
  end
  
end
