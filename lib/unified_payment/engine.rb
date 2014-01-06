module UnifiedPayment
  class Engine < ::Rails::Engine
    isolate_namespace UnifiedPayment

    config.autoload_paths += %W(#{config.root}/lib)
  end
end
