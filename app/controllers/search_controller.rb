class SearchController < ApplicationController
  skip_authorization_check

  def index
    @find_data =  if params[:resource] && params[:query]
                    resource_to_klass.search(query)
                  else
                    []
                  end
  end

  private

  def query
    params[:query]
  end

  def resource_to_klass
    params[:resource].capitalize.constantize
  end
end
