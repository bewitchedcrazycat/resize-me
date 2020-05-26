class Image < ApplicationRecord
  validates :name, :url, :content_type, presence: true
end
