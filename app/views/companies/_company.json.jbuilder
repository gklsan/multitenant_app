json.extract! company, :id, :name, :email, :address, :phone, :license, :subdomain, :created_at, :updated_at
json.url company_url(company, format: :json)
