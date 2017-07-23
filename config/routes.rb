Rails.application.routes.draw do
  devise_for :users
  resources :articles do
    resources :comments

    match 'completed/:value', to: 'articles#completed', via: :get
  end

  root to: 'articles#index'
end
