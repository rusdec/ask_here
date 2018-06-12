module Feature
  module Search
    def find_by_context(params)
      params[:input] ||= '.body'
      within params[:input] do
        page.select params[:context], from: 'context'
        page.select params[:per_page], from: 'per_page' if params[:per_page]
        fill_in 'query', with: params[:text]
        click_on 'Find'
      end
    end
  end
end
