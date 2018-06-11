module Feature
  module Search
    def find_by_context(params)
      params[:input] ||= '.body'

      within params[:input] do
        page.select params[:context], from: 'resource'
        fill_in 'query', with: params[:text]
        click_on 'Find'
      end
    end
  end
end
