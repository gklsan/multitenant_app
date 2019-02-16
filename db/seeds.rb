require 'pry-rails'
NUMBER_OF_COMPANIES = (1..4).to_a
NUMBER_OF_USERS = (1..10).to_a
NAMES_OF_DEPARTMENT = ['Sales', 'Production', 'Marketing', 'Quality']

def create_company
  NUMBER_OF_COMPANIES.each do |i|
    company = Company.find_or_create_by(name: "Company #{i}",
                              email: "company#{i}@company.company",
                              address: 'USA',
                              phone: '9876543210',
                              license: "COMP123#{i}",
                              subdomain: "company#{i}"
              )
    puts company.name
  end
end

def seed_department_and_seed
  Company.pluck(:subdomain).each_with_index do |subdomain, idx|
    Apartment::Tenant.switch(subdomain) do

      user_start_at = (idx + 1) * 10

      # ((user_start_at - 9)..(user_start_at - 6)).each_with_index do |i, idx|
      #   puts "idx#{idx}"
      #   name = "#{NAMES_OF_DEPARTMENT[idx]}"
      #   Department.find_or_create_by(name: name, description: "#{name} description.")
      # end
      #
      NAMES_OF_DEPARTMENT.each do |dname|
        department = Department.find_by_name(dname)
        department ||= Department.create(name: dname, description: "#{dname} description.")
      end

      ((user_start_at - 9)..user_start_at).each do |j|
        email = "user#{j}@user.user"
        user = User.find_by_email(email)
        user ||= User.create(name: "User #{j}",
                           phone: "577689403#{j}",
                           address: "USA#{j}",
                           salary: rand(100000..500000),
                           bonus: rand(15000..50000),
                           department: Department.all.sample,
                           email: email,
                           password: "test1234")
        role =  (user_start_at - 6 > j) ? :admin : :employee
        user.add_role(role) if user.roles_name.empty?
      end
    end
  end

  # Company..each_with_index do |company, idx|
  #   binding.pry
  #   puts "-------#{idx}"
    # Apartment::Tenant.switch(company.subdomain) do


      # NAMES_OF_DEPARTMENT.each do |dname|
      #   Department.create(name: dname, description: "#{dname} description.")
      # end
      #
      # NUMBER_OF_USERS.each do |j|
      #   j = (j * idx + 1) + 1
      #   user = User.create(name: "User #{j}",
      #                      phone: "577689403#{j}",
      #                      address: "USA#{j}",
      #                      salary: rand(100000..500000),
      #                      bonus: rand(15000..50000),
      #                      department: Department.all.sample,
      #                      email: "user#{j}@user.user",
      #                      password: "test1234")
      #   puts user.name
      #
      # end
    # end
  # end
end

create_company
seed_department_and_seed