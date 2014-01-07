module UnifiedPayment
  @config = {
              :merchant_name => "verbose",
              :base_uri => 'http://127.0.0.1:5555'
            }

  @valid_config_keys = @config.keys

  # Configure through hash
  def self.configure(opts = {})
    opts.each {|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
  end

  # Configure through yaml file
  def self.configure_with(path_to_yaml_file)
    config = YAML::load(IO.read(path_to_yaml_file))
    global_config = config.select { |key, value| value.class != Hash } || {}
    env_config = config[Rails.env] || {}
    config = global_config.merge(env_config) 
    configure(config)
  end

  def self.config
    @config
  end
end
require "unified_payment/engine"