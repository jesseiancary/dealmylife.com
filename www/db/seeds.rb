# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

    
    Role.create( :name => "administrator" )
    Role.create( :name => "developer" )
    Role.create( :name => "manager" )
    Role.create( :name => "editor" )
    Role.create( :name => "partner" )
    
    admin_user = User.create(
      :email => 'admin@dealmylife.com',
      :password => 'admin1', 
      :password_confirmation => 'admin1'
    )
    admin_user.roles << Role.find_by_name('administrator')
    admin_user.roles << Role.find_by_name('developer')
    admin_user.roles << Role.find_by_name('manager')
    admin_user.roles << Role.find_by_name('editor')
    admin_user.roles << Role.find_by_name('partner')
    
    #Profile.create(
    #  :id => 1,
    #  :user_id => admin_user.id
    #)
    
    Page.create(
      :name => "DealMyLife.com Home",
      :title => "Home", 
      :permalink => "welcome-page", 
      :content => "Welcome to DealMyLife.com"
    )
    Page.create(
      :name => "About DealMyLife.com",
      :title => "About Us",
      :permalink => "about-us", 
      :content => "Welcome to DealMyLife.com"
    )
    
    Widget.create(
      :name => "Navigator",
      :title => "Navigator",
      :head => "",
      :content => ""
    )
    Widget.create(
      :name => "Clock",
      :title => "Time",
      :head => "<%= javascript_include_tag 'jquery/jquery.rotate.1-1.js' %>\n<%= javascript_include_tag 'jquery/jquery.clock.js' %>",
      :content => "<div id='analog-clock' >\n<%= image_tag('clockBg.png', :size => '180x180', :alt => 'clock face') %>\n<div id='hands'>\n<%= image_tag('hourHand.png', :id => 'hourHand', :alt => 'hour hand') %>\n<%= image_tag('minuteHand.png', :id => 'minuteHand', :alt => 'minute hand') %>\n<%= image_tag('secondHand.png', :id => 'secondHand', :alt => 'second hand') %>\n</div>\n</div>"
    )
    Widget.create(
      :name => "Google Map",
      :title => "Map",
      :head => "<script type='text/javascript' src='http://maps.google.com/maps/api/js?sensor=false'></script><script type='text/javascript'>\n$(document).ready(function() { var latlng = new google.maps.LatLng(34, -118);  var myOptions = { zoom: 8, center: latlng, mapTypeId: google.maps.MapTypeId.ROADMAP }; var map = new google.maps.Map(document.getElementById('map_canvas'), myOptions);});\n</script>",
      :content => "<div id='map_canvas'></div>"
    )
    
    State.create( :name => "Alabama",     :abbr => "AL" )
    State.create( :name => "Alaska",      :abbr => "AK" )
    State.create( :name => "Arizona",     :abbr => "AZ" )
    State.create( :name => "Arkansas",      :abbr => "AR" )
    State.create( :name => "California",    :abbr => "CA" )
    State.create( :name => "Colorado",      :abbr => "CO" )
    State.create( :name => "Connecticut",   :abbr => "CT" )
    State.create( :name => "Delaware",      :abbr => "DE" )
    State.create( :name => "Florida",     :abbr => "FL" )
    State.create( :name => "Georgia",     :abbr => "GA" )
    State.create( :name => "Hawaii",      :abbr => "HI" )
    State.create( :name => "Idaho",       :abbr => "ID" )
    State.create( :name => "Illinois",      :abbr => "IL" )
    State.create( :name => "Indiana",     :abbr => "IN" )
    State.create( :name => "Iowa",        :abbr => "IA" )
    State.create( :name => "Kansas",      :abbr => "KS" )
    State.create( :name => "Kentucky",      :abbr => "KY" )
    State.create( :name => "Louisiana",     :abbr => "LA" )
    State.create( :name => "Maine",       :abbr => "ME" )
    State.create( :name => "Maryland",      :abbr => "MD" )
    State.create( :name => "Massachusetts",   :abbr => "MA" )
    State.create( :name => "Michigan",      :abbr => "MI" )
    State.create( :name => "Minnesota",     :abbr => "MN" )
    State.create( :name => "Mississippi",   :abbr => "MS" )
    State.create( :name => "Missouri",      :abbr => "MO" )
    State.create( :name => "Montana",     :abbr => "MT" )
    State.create( :name => "Nebraska",      :abbr => "NE" )
    State.create( :name => "Nevada",      :abbr => "NV" )
    State.create( :name => "New Hampshire",   :abbr => "NH" )
    State.create( :name => "New Jersey",    :abbr => "NJ" )
    State.create( :name => "New Mexico",    :abbr => "NM" )
    State.create( :name => "New York",      :abbr => "NY" )
    State.create( :name => "North Carolina",  :abbr => "NC" )
    State.create( :name => "North Dakota",    :abbr => "ND" )
    State.create( :name => "Ohio",        :abbr => "OH" )
    State.create( :name => "Oklahoma",      :abbr => "OK" )
    State.create( :name => "Oregon",      :abbr => "OR" )
    State.create( :name => "Pennsylvania",    :abbr => "PA" )
    State.create( :name => "Rhode Island",    :abbr => "RI" )
    State.create( :name => "South Carolina",  :abbr => "SC" )
    State.create( :name => "South Dakota",    :abbr => "SD" )
    State.create( :name => "Tennessee",     :abbr => "TN" )
    State.create( :name => "Texas",       :abbr => "TX" )
    State.create( :name => "Utah",        :abbr => "UT" )
    State.create( :name => "Vermont",     :abbr => "VT" )
    State.create( :name => "Virginia",      :abbr => "VA" )
    State.create( :name => "Washington",    :abbr => "WA" )
    State.create( :name => "West Virginia",   :abbr => "WV" )
    State.create( :name => "Wisconsin",     :abbr => "WI" )
    State.create( :name => "Wyoming",     :abbr => "WY" )
    