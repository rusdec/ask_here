require_relative '../features_helper'
require 'capybara/email/rspec'

feature 'DailyMailers' do
  let(:user) { create(:user) }
  let!(:questions) { create_list(:question, 3, user: user) }

  background do
    clear_emails
    DailyMailer.digest(user).deliver_now
    open_email(user.email)
  end

  scenario 'email has valid subject' do
    expect(current_email.subject).to eq('Daily digest: New questions')
  end

  context 'when content type is html' do
    scenario 'email contains header' do
      expect(current_email).to have_content('New questions for the last day')
    end

    scenario 'email contains links of questions' do
      questions.each do |question|
        expect(current_email).to have_link(question.title)
      end
    end

    scenario 'question link open valid page' do
      question = questions.last
      current_email.click_link question.title
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end
  end

  context 'when content type is plain text' do
    let(:mail) { DailyMailer.digest(user) }
    let(:body) do
      mail.body.parts.select do |part|
        part.header.fields.find do |field|
          field.name == 'Content-Type' && field.value == 'text/plain'
        end
      end.first
    end

    scenario 'email contains questions titles' do
      questions.each do |question|
        expect(body).to have_content(question.title)
      end
    end

    scenario 'email contains header' do
      expect(body).to have_content('New questions for the last day')
    end
  end

end
