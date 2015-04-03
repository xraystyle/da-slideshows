require 'sidekiq/web'
require 'sidetiq/web'

Rails.application.routes.draw do

  get 'slideshows/channels'

  get 'slideshows/slideshow'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root "static_pages#home"

  devise_for :users, controllers: { registrations: "registrations" }


  match 'slideshows/update_slideshow',	to: 'slideshows#update_slideshow', 	via: 'post'
  match 'slideshows/update_slideshow',	to: 'slideshows#update_slideshow', 	via: 'get'
  match 'slideshows/', 					        to: 'static_pages#home', 			      via: 'get'
  match 'slideshows/home',              to: 'slideshows#home',              via: 'get'
  match 'slideshows/foo',               to: 'slideshows#foo',               via: 'post' 

  # match "/users",				to: 'static_pages#home', via: 'get'
  # get 'static_pages/home'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
