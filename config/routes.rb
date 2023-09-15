Rails.application.routes.draw do
  root "health#index"

  get "health", to: "health#index"

  # keyserver endpoints
  post "keyserver/generate(/:count)", to: "key_store#generate"
  get "keyserver/issue", to: "key_store#getRandom"
  put "keyserver/unblock/:key", to: "key_store#unblock"
  delete "keyserver/:key", to: "key_store#delete"
  put "keyserver/refresh/:key", to: "key_store#refresh"
  get "keyserver/validate/:key", to: "key_store#validate" 

end
