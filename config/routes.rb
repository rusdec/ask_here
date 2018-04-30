Rails.application.routes.draw do
  root to: 'questions#index'

  #devise_for :users, path: ''
  devise_for :users, skip: [:sessions]
  as :user do
    get :sign_in, to: 'devise/sessions#new', as: :new_user_session
    post :sign_in, to: 'devise/sessions#create', as: :user_session
    delete :sign_out, to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :questions do
    resources :answers, shallow: true,
                        only: %i[create update destroy] do
      patch :best_answer, on: :member 
      patch :not_best_answer, on: :member 
    end

    post :like, on: :member
  end

  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html
end
