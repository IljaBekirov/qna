Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :files, only: [:destroy]
  resources :questions do
    resources :answers, shallow: true do
      patch :mark_as_best, on: :member
    end
  end
end
