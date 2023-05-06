Rails.application.routes.draw do
  root to: 'boards#new'
  resources :boards, except: [:edit, :update, :edit]
end
