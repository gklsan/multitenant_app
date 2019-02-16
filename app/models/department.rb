class Department < ApplicationRecord
  resourcify
  has_many :users
  validates :name, presence: true
end
