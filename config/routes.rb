Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users, skip: [:sessions]
  as :user do
    get :sign_in, to: 'devise/sessions#new', as: :new_user_session
    post :sign_in, to: 'devise/sessions#create', as: :user_session
    delete :sign_out, to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  concern :votable do |options|
    member do
      post :vote, to: "#{options[:controller]}#add_vote"
      delete :vote, to: "#{options[:controller]}#cancel_vote"
    end
  end

  resources :comments, only: %i[destroy update]
  concern :commentable do |options|
    post :comments, to: "#{options[:controller]}#create_comment"
  end

  resources :questions do
    resources :answers, shallow: true,
                        only: %i[create update destroy] do
      patch :best_answer, on: :member 
      patch :not_best_answer, on: :member 
      concerns :votable, controller: :answers
    end
    concerns :votable, controller: :questions
    concerns :commentable, controller: :questions
  end

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html
end
