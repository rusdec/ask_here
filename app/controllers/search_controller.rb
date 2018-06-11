class SearchController < ApplicationController
  skip_authorization_check

  def index
    @current_query = current_query
    @find_data =  if params[:resource] && params[:query]
                    resource_to_klass.search(query)
                  else
                    []
                  end
  end

  private

  def current_query
     params[:query] || ''
  end

  def query
    params[:query]
  end

  def resource_to_klass
    params[:resource].capitalize.constantize
  rescue
    params[:resource] = ThinkingSphinx
  end
end
