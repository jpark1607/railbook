class Book < ActiveRecord::Base

	has_many :reviews
	has_and_belongs_to_many :authors

	scope :jpub, -> { where(publish: '제이펍') }
	scope :newer, -> { order(published: :desc) }
	scope :top10, -> { newer.limit(10) }
end
