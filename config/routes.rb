Rails.application.routes.draw do
  root "health#index"

  get "health", to: "health#index"

  # keyserver endpoints
  get "keyserver/generate(/:count)", to: "key_store#generate"
  get "keyserver/fetch", to: "key_store#getRandom"
  put "keyserver/unblock/:key", to: "key_store#unblock"
  delete "keyserver/:key", to: "key_store#delete"
  post "keyserver/refresh/:key", to: "key_store#refresh"

end
