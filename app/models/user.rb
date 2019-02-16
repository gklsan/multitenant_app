class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,# :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :department
  attr_accessor :role_type

  validates :name, :salary, :bonus, presence: true
  validates :phone, presence: true, length: { is: 10 }
  validates :email, presence: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }

  def has_admin_role?
    roles_name.include?('admin')
  end

  def role_name
    roles_name.first
  end

  def department_name
    department&.name
  end

  def set_role(role_type)
    self.add_role(role_type.to_sym)
  end

  def remove_existing_role(role_type)
    self.remove_role(role_type.to_sym)
  end

end
