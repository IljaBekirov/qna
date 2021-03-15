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

  concern :commentable do
    member do
      post :add_comment
    end
  end

  resources :files, only: [:destroy]
  resources :questions, concerns: %i[voted commentable] do
    resources :answers, concerns: %i[voted commentable], shallow: true do
      patch :mark_as_best, on: :member
    end
  end

  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
