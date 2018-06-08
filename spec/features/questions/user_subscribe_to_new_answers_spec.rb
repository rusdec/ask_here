require_relative '../features_helper'

feature 'User describe to question for new answers', %q{
  As user
  I can subscribe to question
  so that I can receive notifications about new replies
} do

  let(:question) { create(:question, user: create(:user)) }
  let(:subscribable) do
    { resource: question,
      uri: question_path(question)}
  end
  it_behaves_like 'subscribable'
end
