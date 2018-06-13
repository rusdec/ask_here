class SearchController < ApplicationController
  include Paginated

  before_action :set_query
  before_action :set_raw_query
  before_action :set_context
  before_action :set_raw_context

  def index
    @resources = @query.empty? ? [] : @context.search(@query,
                                                      page: @page,
                                                      per_page: @per_page)
    authorize! :read, @resources
  end

  private

  def set_raw_query
    @raw_query = params[:query] || ''
  end

  def set_query
    @query = params[:query] ? ThinkingSphinx::Query.escape(params[:query]) : ''
  end

  def set_raw_context
    @raw_context = params[:context]
  end

  def set_context
    @context = params[:context].capitalize.constantize
  rescue
    @context = ThinkingSphinx
  end
end
