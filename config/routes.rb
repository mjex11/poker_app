Rails.application.routes.draw do
  root to: 'poker#index'
  post 'poker/submit', to: 'poker#submit', as: 'submit_poker_index'
end
