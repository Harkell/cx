class CompaniesController < ApplicationController
  def index
  end

  def show
  	@company = Company.find_by(company_number: params[:company_number])
  end
end
