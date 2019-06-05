Rails.application.routes.draw do
  root controller: :hello_dockers, action: :index

  resources :hello_dockers do
    collection do
      post "index_add"
      delete "index_destroy"
    end
  end


end
