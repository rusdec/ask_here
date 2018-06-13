module Paginated
  extend ActiveSupport::Concern

  included do
    before_action :set_page, only: :index
    before_action :set_per_page, only: :index

    PER_PAGE = 20.freeze
    DEFAULT_PAGE = 1.freeze

    private

    def set_page
      @page = params[:page] || DEFAULT_PAGE
    end

    def set_per_page
      @per_page = params[:per_page] || PER_PAGE
    end
  end
end
