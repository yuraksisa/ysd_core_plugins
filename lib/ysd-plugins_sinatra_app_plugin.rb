require 'sinatra/base'

module Plugins

  #
  # It's a plugin for a sinatra app
  #
  class SinatraAppPlugin < Plugin
    
    # initialize
    #
    def initialize(id)
      super
    end

    #
    # Register a plugin
    #
    # @param [Symbol] id
    # @param [Block] block
    # 
    #
    def self.register(id, &block)
    
      # Create the plugin
      plugin = SinatraAppPlugin.new(id)
      plugin.instance_eval(&block)   

      # Store it
      plugins.store(id.to_sym, plugin) 
           
    end

        
    #
    # Registers a helper
    #
    # @param [Class] helper_class 
    #
    def sinatra_helper(helper_class)
      sinatra_helpers << helper_class
    end
    
    #
    # Registers an extension
    #
    # @param [Class] extension_class
    #
    #
    def sinatra_extension(extension_class)
      sinatra_extensions << extension_class
    end
    
    #
    # @param [Sinatra::Base] application
    #
    def init(application)
    
      unless application.ancestors.index(Sinatra::Base)
        raise ArgumentError, "application #{application} must extend Sinatra::Base is : #{application.ancestors}"
      end
            
      # Initializes the plugins
      
      sinatra_helpers.each do |helper|
        if application.respond_to?(:helpers)
          application.helpers helper
        end
      end

      sinatra_extensions.each do |extension|
        if application.respond_to?(:register)
          application.register extension
        end
      end
      
      Plugins::Plugin.plugin_invoke(id, 'init', {:app => application})
      
    end
        
    private
    
    #
    # Returns all sinatra helpers
    #
    def sinatra_helpers
      @sinatra_helpers ||= []
    end
    
    #
    # Return all sinatra extensions
    #
    def sinatra_extensions
      @sinatra_extensions ||= []
    end
    
  end
end