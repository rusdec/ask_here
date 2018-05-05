Rails.application.routes.draw do
  root to: 'questions#index'

  #devise_for :users, path: ''
  devise_for :users, skip: [:sessions]
  as :user do
    get :sign_in, to: 'devise/sessions#new', as: :new_user_session
    post :sign_in, to: 'devise/sessions#create', as: :user_session
    delete :sign_out, to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  concern :votable do |options|
    member do
      post :vote, to: "#{options[:model]}#create_vote"
      delete :vote, to: "#{options[:model]}#destroy_vote"
      patch :vote, to: "#{options[:model]}#update_vote"
    end
  end

  resources :questions do
    resources :answers, shallow: true,
                        only: %i[create update destroy] do
      patch :best_answer, on: :member 
      patch :not_best_answer, on: :member 
      concerns :votable, model: :answers
    end
    concerns :votable, model: :questions
  end

  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html
end
