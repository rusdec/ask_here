module Feature
  module Vote
    def like
      click_vote('Like')
    end

    def dislike
      click_vote('Dislike')
    end

    def click_vote(name)
      click_on name
    end
  end
end
