class SearchController < ApplicationController
  before_action :set_query
  before_action :set_raw_query
  before_action :set_context
  before_action :set_page
  before_action :set_per_page

  PER_PAGE = 20.freeze

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

  def set_context
    @context = params[:resource].capitalize.constantize
  rescue
    @context = ThinkingSphinx
  end

  def set_page
    @page = params[:page] || 1
  end

  def set_per_page
    @per_page = params[:per_page] || PER_PAGE
    puts "PER PAGE: #{@per_page}"
  end
end
