require 'rails/generators'
module UnifiedPayment
  class InstallGenerator < Rails::Generators::Base
    desc "Some description of my generator here"

    # Commandline options can be defined here using Thor-like options:
    class_option :my_opt, :type => :boolean, :default => false, :desc => "My Option"

    # I can later access that option using:
    # options[:my_opt]


    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    # Generator Code. Remember this is just suped-up Thor so methods are executed in order
    def create_migrations
      Dir["#{self.class.source_root}/migrations/*.rb"].sort.each do |filepath|
        name = File.basename(filepath)
        template "migrations/#{name}", "db/migrate/#{name}"
        sleep 1
      end
    end
  end
end