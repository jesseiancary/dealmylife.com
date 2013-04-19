#require "openid/store/filesystem"
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "165852260160527", "3c7b0b1847a760a5c41668195c99da1f", :scope => 'email,offline_access,user_activities,user_interests,user_location', :display => 'page'
  provider :twitter, "9CgfYE4zY4yl1SSPp0Dg", "2IsKAR9qeIrUKxvKCSMp4BwfHGaODZl3qvicz1QxSPc"
  #provider :open_id, OpenID::Store::Filesystem.new("/tmp")
end

# Twitter: DealMyLife1 getrich1