Rails.application.routes.draw do
  get '/unified_transactions', :to => 'transactions#index'
  # mount UnifiedPayment::Engine => "/unified_payment"
end
