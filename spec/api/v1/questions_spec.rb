require 'rails_helper'

describe 'Questions API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /index' do
    let (:uri) { "#{api_v1_questions_path}.json" }

    context 'when unauthorized' do
      context 'and isn\'t access_token ' do
        it 'returns status 401' do
          get uri
          expect(response.status).to eq(401)
        end
      end

      context 'and access_token is invalid' do
        it 'returns status 401' do
          get uri, params: { access_token: 'invalid_token' }
          expect(response.status).to eq(401)
        end
      end
    end # context 'when unauthorized'

    context 'when authorized' do
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question, user: question.user) }

      before do
        get uri, params: { access_token: access_token.token }
      end

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns two questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(
            question.send(attr.to_sym).to_json
          ).at_path("questions/0/#{attr}")
        end
      end

      %w(comments answers attachements).each do |attr|
        it "question object not contains #{attr}" do
          expect(response.body).to_not have_json_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json)
          .at_path('questions/0/short_title')
      end
    end # context 'when authorized'
  end # describe 'GET /index'

  describe 'GET /show' do
    let!(:question) { create(:question, user: user) }
    let!(:comment) { create(:comment, commentable: question, user: user) }
    let!(:attachement) { create(:attachement, attachable: question) }

    let (:uri) { "#{api_v1_question_path(question)}.json" }

    context 'when unauthorized' do
      context 'and isn\'t access_token ' do
        it 'returns status 401' do
          get uri
          expect(response.status).to eq(401)
        end
      end

      context 'and access_token is invalid' do
        it 'returns status 401' do
          get uri, params: { access_token: 'invalid_token' }
          expect(response.status).to eq(401)
        end
      end
    end # context 'when unauthorized'

    context 'when authorized' do
      before do
        get uri, params: { access_token: access_token.token }
      end

      it 'returns status 200' do
        expect(response).to be_successful
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json)
            .at_path("question/#{attr}")
        end
      end

      %w(short_title answers).each do |attr|
        it "question object not contains #{attr}" do
          expect(response.body).to_not have_json_path("question/#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('question/comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "comment object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json)
              .at_path("question/comments/0/#{attr}")
          end
        end

        %w(commentable_id commentable_type user_id).each do |attr|
          it "comment object not contains #{attr}" do
            expect(response.body).to_not have_json_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachements' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('question/attachements')
        end

        %w(name).each do |attr|
          it "attachement object contains #{attr}" do
            expect(response.body).to be_json_eql(attachement.send(attr.to_sym).to_json)
              .at_path("question/attachements/0/#{attr}")
          end
        end

        %w(id).each do |attr|
          it "attachement object not contains #{attr}" do
            expect(response.body).to_not have_json_path("question/attachements/0/#{attr}")
          end
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attachement.file.url.to_json)
            .at_path('question/attachements/0/url')
        end
      end
    end # context 'when authorized'
  end
end
