Rails.application.routes.draw do
  
  resources :vocess_locutors, :home_concursos
  devise_for :administrators
  resources :concursos do
    resources :voces_locutors, :vocess_locutors 
  end
  resources :home_concursos do
    resources :concursos 
  end
  #, :voces_locutor
  
  get 'home/index'
  get '/homeConcursos' => 'concursos#homeConcursos'
  #get 'concurso',to: 'concurso#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

end
