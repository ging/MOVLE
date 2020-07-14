require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module MOVLE
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    #Automatically connect to the database when a rails console is started
    console do
      ActiveRecord::Base.connection
    end
    
    #Load MOVLE Platform configuration
    #Accesible here: MOVLE::Application.config.APP_CONFIG
    config.APP_CONFIG = YAML.load_file("config/application_config.yml")[Rails.env]
    config.domain = (config.APP_CONFIG["domain"] || "localhost:3000")
    config.full_domain = "http://" + config.domain
    config.full_code_domain = "http://" + (config.APP_CONFIG['code_domain'] || config.APP_CONFIG['domain'])

    config.name = (config.APP_CONFIG["name"] || "MOVLE")
    config.platform_version = "0.1"

    # I18n (http://guides.rubyonrails.org/i18n.html)
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en
    config.i18n.available_locales = [config.i18n.default_locale, :es].uniq
    # I18n fallbacks: rails will fallback to config.i18n.default_locale translation
    config.i18n.fallbacks = true

    #Tags settings
    config.tagsSettings = (config.APP_CONFIG['tagsSettings'] || {})
    default_tags = {
        "minLength" => 2,
        "maxLength" => 20,
        "maxTags" => 10,
        "tagSeparators" => [',',';'],
        "triggerKeys" => ['enter', 'comma', 'tab', 'space']
    }
    config.tagsSettings = default_tags.merge(config.tagsSettings)
    config.stoptags = File.read("config/stoptags.yml").split(",").map{|s| s.gsub("\n","").gsub("\"","") } rescue []
    ActsAsTaggableOn.strict_case_match = true

    #Require core extensions
    Dir[File.join(Rails.root, "lib", "core_ext", "*.rb")].each {|l| require l }
    Dir[File.join(Rails.root, "lib", "acts_as_taggable_on", "*.rb")].each {|l| require l }

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enable the asset pipeline
    config.assets.enabled = true

    #Recaptcha
    config.recaptcha = (config.APP_CONFIG["recaptcha"] && !config.APP_CONFIG["recaptcha"]["site_key"].blank? && !config.APP_CONFIG["recaptcha"]["secret_key"].blank?)

    if config.recaptcha
        Recaptcha.configure do |config|
            config.site_key  = MOVLE::Application.config.APP_CONFIG["recaptcha"]["site_key"]
            config.secret_key = MOVLE::Application.config.APP_CONFIG["recaptcha"]["secret_key"]
        end
    end

    config.after_initialize do
        if ActiveRecord::Base.connected?
          #Agnostic random
          if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
            config.agnostic_random = "RANDOM()"
          else
            MySQL
            config.agnostic_random = "RAND()"
          end

          #Demo user
          config.demo_user = User.find_by_email("demo@movle.dit.upm.es") if (ActiveRecord::Base.connection.table_exists? "users" and !User.find_by_email("demo@movle.dit.upm.es").nil?) 
        end 
    end

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
  end
end