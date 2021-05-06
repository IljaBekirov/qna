class SearchesController < ApplicationController
  skip_authorization_check

  def index
    if params[:query].present?
      @results = Search.call(query_params)
    else
      redirect_to root_path, alert: 'Search can`t be blanc'
    end
  end

  private

  def query_params
    params.permit(:query, :scope)
  end
end
