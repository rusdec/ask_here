module Feature
  module Vote
    def like(params)
      params[:name] = 'Like'
      choose_for(params)
    end

    def dislike(params)
      params[:name] = 'Dislike'
      choose_for(params)
    end

    def choose_for(params)
      within params[:context] do
        click_on params[:name]
      end
    end
  end
end
