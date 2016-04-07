Rails.application.routes.draw do
  root 'pages#home'

  post :next_step, to: 'pages#next_step'
  post :result, to: 'pages#result'
  get :social_card, to: 'pages#social_card'
end
