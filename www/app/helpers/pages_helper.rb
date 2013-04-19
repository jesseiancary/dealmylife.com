module PagesHelper
  
  def get_locations
    
    Page.where("location != ''").all(
      :select => [:location],
      :group => 'location'
    )
    
  end
  
end
