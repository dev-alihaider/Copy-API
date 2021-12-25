Rails.application.routes.draw do
  get '/copy', to: 'copy#index'
  get '/copy/refresh', to: 'copy#refresh'
  get '/copy/:key', to: 'copy#show', key: /[^\/]+/
end
