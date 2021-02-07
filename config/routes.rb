Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope module: :v1 do
    resources :orders, only: [:create]
  end
end
