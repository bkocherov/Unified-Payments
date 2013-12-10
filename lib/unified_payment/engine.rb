module UnifiedPayment
  class Engine < Rails::Engine
    engine_name 'unified_payment'

    config.autoload_paths += %W(#{config.root}/lib)
  end
end
