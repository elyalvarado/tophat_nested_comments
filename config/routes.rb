Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
 
  # Skip generating the routes for devise, and generate them manually
  devise_for :users, skip: :all
  as :user do
    scope "api" do
      post "sign_in", to: "sessions#create", as: :user_session
      post "sign_up", to: "registrations#create", as: :user_registration
    end
  end
end

