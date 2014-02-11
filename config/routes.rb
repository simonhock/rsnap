Rsnap::Application.routes.draw do
  resources :programs

  resources :file_missions

  resources :missions
  resources :program_mission_initializations, :only=>:new

  devise_for :users, :path => "auth", :controllers => { :registrations => "registrations" }
  resources :users

  resources :snap_assets, :only=>:index

  root :to => "home#index"
end
