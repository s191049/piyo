Rails.application.routes.draw do
  post 'posts/create'
  get 'posts/create'
  
  get 'boards/index'
  get 'boards/new'
  post 'boards/create'
  get 'boards/create'
  get 'boards/show/:id', to: 'boards#show', as: 'boards_show'
  
  get 'cars/new'
  post 'cars/confirm'
  get 'cars/confirm'
  post 'cars/create'
  get 'cars/create'
  get 'cars/index'
  get 'cars/index/:leading_digit', to: 'cars#index'
  get 'cars/show/:id', to: 'cars#show', as: 'cars_show'
  get 'cars/edit/:id', to: 'cars#edit', as: 'cars_edit'
  patch 'cars/update/:id', to: 'cars#update', as: 'cars_update'
  delete 'cars/destroy/:id', to: 'cars#destroy', as: 'cars_destroy'
  get 'cars/search'
  post 'cars/search'
  get 'cars/import'
  post 'cars/import'
  get 'cars/export'
  get 'cars/bulk_new'
  post 'cars/bulk_create'
  get 'cars/excel_export'
  
  root 'static_pages#home'
  get '/help',		to: 'static_pages#help'
  get '/about',		to: 'static_pages#about'
  get '/contact',	to: 'static_pages#contact'
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
