Rails.application.routes.draw do

  resources :promocions

  resources :tarjeta

  get 'logins/logout'

  get 'logins/intento_login'

  post 'logins/intento_login'

  resources :usuarios, :path_names => { :new => 'registro', :edit => 'editar', :show => 'me' }
  

  resources :logins, only: [:index, :create, :destroy], :path_names =>{:create => 'do'}

  namespace :nosotros do
    resources :aviones , only: [:show, :index]
  end

  namespace :api do
    resources :aviones
    resources :vuelos

  end

  get 'aviones/index'

  resources :promociones , only: [:show, :index]

  resources :tarjetas , only: [:show]

  resources :usuarios, only: [:show, :new]

  resources :login, only: [:show, :index, :destroy]


  resources :welcome, only: [:index]

  resources :vuelos, only: [:show, :index]

  resources :ciudades, only: [:show, :index]

  namespace :nosotros do
    resources :aviones, only: [:show, :index]
  end


  get 'avions/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'welcome#index'

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

  namespace :api, :defaults => {:format => :json}  do

    resources :promociones , only: [:show, :index]

    resources :tarjetas , only: [:show]

    resources :usuarios, only: [:show]

    resources :logins, only: [:show]

    resources :aviones, only: [:show, :index]

    resources :welcome, only: [:show ]

    resources :vuelos, only: [:show, :index]

    resources :ciudades, only: [:show, :index]
  end
end
