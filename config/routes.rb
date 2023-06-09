# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      resources :posts, only: %i[index show create update destroy]
      resources :comments, only: %i[index show create update destroy]
    end
  end
end
