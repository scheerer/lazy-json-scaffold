class Post < ActiveRecord::Base
  scope :active, -> { where(active: true) }
end
