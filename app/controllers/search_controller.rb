class SearchController < ApplicationController
  before_action :set_query
  before_action :set_context

  def index
    @resources = @query.empty? ? [] : @context.search(@query)
    authorize! :read, @resources
  end

  private

  def set_query
    @query = params[:query] ? ThinkingSphinx::Query.escape(params[:query]) : ''
  end

  def set_context
    @context = params[:resource].capitalize.constantize
  rescue
    @context = ThinkingSphinx
  end
end
