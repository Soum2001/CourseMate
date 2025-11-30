class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # before_action :set_current_institution
  # before_action :switch_tenant_db
  respond_to :html, :turbo_stream
  def set_current_institution
    tenant_identifier = params[:tenant]
    binding.pry
    Current.institution = Institution.find_by(identifier: tenant_identifier)
  end
  
  def switch_tenant_db
    return unless Current.institution
  
    ActiveRecord::Base.establish_connection(
      adapter:  "mysql2",
      host:     Current.institution.db_host || ENV["DATABASE_HOST"],
      port:     Current.institution.db_port || ENV["DATABASE_PORT"],
      database: Current.institution.db_name,
      username: Current.institution.db_username,
      password: Current.institution.db_password,
      host:     Current.institution.db_host
    )
    
  end
  def authenticate_user!
    super
  rescue UncaughtThrowError
    redirect_to new_user_session_path, alert: "Please log in."
  end
  

end
