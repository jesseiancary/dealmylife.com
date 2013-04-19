class ProfileAddress < ActiveRecord::Base
  validates_presence_of :label
	belongs_to :profile
	belongs_to :address, :dependent => :destroy
end
