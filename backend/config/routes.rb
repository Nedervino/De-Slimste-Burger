Rails.application.routes.draw do
  match '*all', to: proc { [204, {}, ['']] }, via: :options
  
  resources :results, only: :create
  resources :games, only: %i(show create) do
    resources :results, only: :index
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
