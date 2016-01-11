class User < ActiveRecord::Base
	has_one :author

	#validates :agreement, acceptance: true
	validates :agreement, acceptance: { accept: 'yes' }
end
