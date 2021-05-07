class CompaniesController < ApplicationController
  def show
    @company = Company.approved.unarchived.find(params[:id])
  end
end
