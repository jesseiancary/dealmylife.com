module AddressesHelper
  
  def get_profile_addresses_selectbox ( id = "a" )
    addresses = logged_in_user.profile.addresses.all
    html = ""
    html << "<select id='#{id}' name='#{id}'>"
    if !addresses.empty?
      addresses.each do |address| 
        html << "<option value='#{address.id}'>#{address.label} - #{address.to_s}</option>"
      end
    else
      html << "<option disabled='disabled'>You have no saved addresses.</option>"
    end
    html << "</select>"
    html.html_safe
  end
  
  def get_states
    State.all(:order => :name)
  end
  
end
