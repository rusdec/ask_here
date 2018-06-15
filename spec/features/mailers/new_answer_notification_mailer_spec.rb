require_relative '../features_helper'
require 'capybara/email/rspec'

feature 'NewAnswerNotificationMailer' do
  let!(:question) { create(:question_with_answers, user: create(:user)) }
  let(:answer) { question.answers.last }
  let(:subscription) { create(:subscription, subscribable: question,
                              user: create(:user)) }

  background do
    clear_emails
    NewAnswerNotificationMailer.notify(user: subscription.user,
                                       answer: answer).deliver_now
    open_email(subscription.user.email)
  end

  scenario 'email has valid subject' do
    expect(current_email.subject).to eq('Ask question: New answer for question')
  end

  context 'when content type is html' do
    scenario 'email contains header' do
      expect(current_email).to have_content('New answer')
    end

    scenario 'email contains links of questions' do
      expect(current_email).to have_link('Open question page')
    end

    scenario 'question link open valid page' do
      current_email.click_link 'Open question page'
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end

    scenario 'email contains answer body' do
      expect(current_email).to have_content(answer.body)
    end
  end

  context 'when content type is plain text' do
    let(:mail) { NewAnswerNotificationMailer.notify(user: subscription.user,
                                                    answer: answer) }
    let(:body) do
      mail.body.parts.select do |part|
        part.header.fields.find do |field|
          field.name == 'Content-Type' && field.value == 'text/plain'
        end
      end.first
    end

    scenario 'email contains questions titles' do
      expect(body).to have_content(question.title)
    end

    scenario 'email contains answer body' do
      expect(body).to have_content(answer.body)
    end
  end
end
