Rails.application.routes.draw do
  resources :questions do
    resources :answers, shallow: true,
                        only: %i[index new create update destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
