module ApplicationHelper
  def current_users_company
    subdomain = Apartment::Tenant.current
    Company.find_by_subdomain(subdomain) rescue nil
  end

  def current_user_has_role?(role)
    current_user && current_user.has_role?(role.to_sym)
  end
end
