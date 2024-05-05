
Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }

  authenticated :user do
    root 'users#index', as: :authenticated_root
    resources :users do
      member do
        patch :block
        patch :unblock
      end
      collection do
        patch :block_users
        patch :unblock_users
        delete :delete_users
      end
    end
  end

    root to: 'home#index'
end