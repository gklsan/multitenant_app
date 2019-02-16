class Company < ApplicationRecord
  after_create :create_tenant
  validates :name, :address, :license, :subdomain, presence: true
  validates :phone, presence: true, length: { is: 10 }
  validates :email, presence: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }

  def create_tenant
    Apartment::Tenant.create(subdomain)
  end
end
