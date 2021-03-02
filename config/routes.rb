Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :voted do
    member do
      patch :vote_up
      patch :vote_down
      delete :vote_cancel
    end
  end

  resources :files, only: [:destroy]
  resources :questions, concerns: :voted do
    resources :answers, concerns: :voted, shallow: true do
      patch :mark_as_best, on: :member
    end
  end

  resources :rewards, only: :index
end
