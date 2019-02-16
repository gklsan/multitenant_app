class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :employee_redirect, except: [:show, :edit]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all.order(created_at: :desc)
    @reports = User.find_by_sql(top_salary_report_sql)
    @company =  Company.find_by_subdomain(Apartment::Tenant.current)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params.merge(password: 'test1234'))
    respond_to do |format|
      if @user.save
        @user.set_role(user_params[:role_type])
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        update_role
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by_id(params[:id]) || current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :phone, :address, :salary, :bonus, :email, :password, :department_id, :role_type)
  end


  def employee_redirect
    redirect_to root_path && return unless current_user.present?
    redirect_to user_path(current_user) and return if current_user.has_role?(:employee)
  end

  def top_salary_report_sql
    sql = %(
             SELECT u1.name uname, d.name dname, salary, department_id FROM users u1
             INNER JOIN departments AS d
             ON d.id = u1.department_id
             WHERE 3 > (
               SELECT COUNT(DISTINCT Salary)
               FROM users u2
               WHERE u2.salary > u1.salary AND u2.department_id = u1.department_id
             )
             ORDER BY d.name ASC, Salary DESC
           )
  end

  def update_role
    current_role = @user.roles_name.first
    if current_role != user_params[:role_type]
      @user.remove_existing_role(current_role.to_sym) if current_role.present?
      @user.set_role(user_params[:role_type])
    end
  end
end
