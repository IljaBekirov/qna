Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'

  get '/user/get_email', to: 'users#new'
  post '/user/set_email', to: 'users#create'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit], shallow: true
      end
    end
  end

  concern :voted do
    member do
      patch :vote_up
      patch :vote_down
      delete :vote_cancel
    end
  end

  concern :commentable do
    resources :comments, only: :create, shallow: true
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
