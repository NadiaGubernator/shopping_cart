Rails.application.routes.draw do
	root 'store#index', as: 'store_index'

	resources :products do
		get :who_bought, on: :member
	end

	resources :carts

  resources :line_items do
  	patch :decrement, on: :member
  end

  resources :orders

  get '/api', to: 'api#grab'
end
