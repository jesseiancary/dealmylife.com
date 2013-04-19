module ApplicationHelper
  
  def get_pages (location)
    Page.find_all_by_enabled_and_location(true, location, :order => "`pages`.`order` ASC")
  end
  
end
