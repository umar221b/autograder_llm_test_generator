Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "llm_queries#new"
  resources :llm_queries, only: %i[index show new create]

end
