Rails.application.routes.draw do
  root "health#index"

  get 'health/index'
end
