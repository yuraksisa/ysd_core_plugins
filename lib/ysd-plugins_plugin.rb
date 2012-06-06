module Plugins

  # It represents a plugin
  #
  # In settings, you can
  #
  #  :hookers, :sinatra_extensions, :sinatra_helpers
  #
  class Plugin
    
    attr_reader :id
    attr_accessor :name, :author, :description, :version, :settings
    
    #
    # Register a plugin
    #
    # @param [Symbol] id
    # @param [Block] block
    # 
    #
    def self.register(id, &block)
    
      # Create the plugin
      plugin = AppPlugin.new(id)
      plugin.instance_eval(&block)      
                    
      # Store it
      plugins.store(id.to_sym, plugin) 
           
    end

    
    # Create a new instance
    #
    def initialize(id)
      @id = id
    end 
    
    # Register a hooker
    #
    # @param [Class] hooker_class
    #
    def hooker(hooker_class)
      hooker_classes << hooker_class
    end    
    
    #
    # Init the plugin in the context of the application
    #
    def init(application)
    
      # Creates an instance of the hooker and hold it in the hookers 
      hooker_classes.each do |hooker_class| 
        hooker = hooker_class.new
        hooker_instances << hooker 
      end    
    
    end
                   
    # Retrieve the list of plugins
    #
    def self.plugins
      @@plugins ||= {}
    end    
     
    #
    # Get the hooker classes
    #
    def hooker_classes
      @hooker_classes ||= []
    end
    
    #
    # Get the hooker instances
    #
    def hooker_instances
      @hookers_instances ||= []
    end    
    
    #
    # Invoke a method on a plugin hooks
    #
    # @param [String] plugin_id
    #  The plugin_id
    #
    # @param [String] hook
    #  The hook to be invoked
    #
    # @param [Hash] context
    #  The context
    #
    # @param [Array] other arguments
    #  Other arguments
    #
    #
    def self.plugin_invoke(plugin_id, hook, context, *args)
       
      results = []
      
      puts "plugin_id :#{plugin_id} #{hook}"
      
      if plugin = @@plugins[plugin_id.to_sym]    
        plugin.hooker_instances.each do |hooker_instance|
          if hooker_instance.class.method_defined?(hook)
            result = hooker_instance.send(hook, context, *args)
            if result.kind_of?(Array)
              results.concat(result)
            else
              results << result
            end  
          else
            puts "Not defined method #{hook} for plugin #{plugin_id}"
          end  
        end
      else
        puts "Not exists plugin #{plugin_id}"
      end
      
      #puts "results (invoke) = #{results.to_json}"
      
      results
    
    end
    
    #
    # Invoke a method on all registered plugin hooks
    #
    # @param [String] hook
    #  The hook to be invoked
    #
    # @param [Hash] context
    #  The context
    #
    # @param [Array] other arguments
    #  Other arguments
    #
    #
    def self.plugin_invoke_all(hook, context, *args)
    
      results = []
   
      @@plugins.each_key do |plugin_id|         
        result = plugin_invoke(plugin_id, hook, context, *args)
        puts "plugin_id :#{plugin_id} hook : #{hook} result : #{result.to_json}"
        results.concat(result)
      end
      
      #puts "results (invoke all) = #{results.to_json}"
      
      results
   
   end
    
             
  end #Plugin
end #Plugins