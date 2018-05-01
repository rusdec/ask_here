module Feature
  module Vote
    def like(params = {})
      params[:name] = 'Like'
      click_vote(params)
    end

    def dislike(params = {})
      params[:name] = 'Dislike'
      click_vote(params)
    end

    def click_vote(params)
      click_button(value: params[:name])
    end
  end
end
