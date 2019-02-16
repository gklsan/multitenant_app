class Department < ApplicationRecord
  resourcify
  has_many :users
end
