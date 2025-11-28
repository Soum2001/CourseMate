class InstitutionsController < ApplicationController
  skip_before_action :switch_tenant_db
  skip_before_action :authenticate_user!, raise: false
  skip_before_action :set_current_institution

  def new
    @institution = Institution.new
  end

  def create
    @institution = Institution.new(institution_params)
    binding.pry
    if @institution.save
      CreateTenantDb.call(@institution)
      redirect_to unauthenticated_root_path(tenant: @institution.identifier)
    else
      flash.now[:alert] = "Something went wrong"
      render :new
    end
  end

  private

  def institution_params
    params.require(:institution).permit(:name, :identifier)
  end
end
