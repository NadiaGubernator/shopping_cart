Rails.application.routes.draw do  
	root 'store#index', as: 'store_index'

	resources :products
	resources :carts

  resources :line_items do
  	patch 'decrement', on: :member
  end
  resources :orders   
end
