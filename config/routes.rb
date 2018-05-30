Rails.application.routes.draw do
  use_doorkeeper
  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers, shallow: true
      end
    end
  end

  devise_for :users, skip: [:sessions],
             controllers: { omniauth_callbacks: 'omniauth_callbacks',
                            registrations: 'users/registrations' }
  as :user do
    get :sign_in, to: 'devise/sessions#new', as: :new_user_session
    post :sign_in, to: 'devise/sessions#create', as: :user_session
    delete :sign_out, to: 'devise/sessions#destroy', as: :destroy_user_session
    post :continue_authorization, to: 'omniauth_callbacks#authorization_after_request_email'
  end

  concern :votable do |options|
    member do
      post :vote, to: "#{options[:controller]}#add_vote"
      delete :vote, to: "#{options[:controller]}#cancel_vote"
    end
  end

  concern :commentable do
    resources :comments, only: %i[destroy update create], shallow: true
  end

  resources :questions do
    resources :answers, shallow: true,
                        only: %i[create update destroy] do
      member do
        patch :best_answer
        patch :not_best_answer
      end

      concerns :votable, controller: :answers
      concerns :commentable
    end
    concerns :votable, controller: :questions
    concerns :commentable
  end

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html
end
