module Feature
  module Search
    def find_by_context(params)
      page.select params[:context], from: 'resource'
      fill_in 'query', with: params[:text]
      click_on 'Find'
    end
  end
end
