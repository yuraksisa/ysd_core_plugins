module Plugins

  #
  # It allows to define an aspect which can be applied to an element to
  # improve their abilities
  #
  #
  class Aspect
    
    attr_reader :id, :description, :applies_to, :delegate, :configuration_attributes
    
    alias old_respond_to? respond_to?
    
    @@aspects = {}
    
    #
    # Constructor
    #
    # @param [String] id
    #  The aspect identifier
    #
    # @param [String] description
    #  The aspect description
    #
    # @param [Array] applies_to
    #  Tags which identifier where the aspect can be applied
    #
    # @param [Object] delegate
    #   How does the aspect applies. An instance to which the aspect will delegate its invokes
    #
    # @param [Array] configuration
    #   An array of AspectConfiguration with the configuration attributes
    #
    def initialize(id, description, applies_to, delegate, configuration_attributes=[])
      @id = id
      @description = description
      @applies_to = applies_to   
      @delegate = delegate
      @configuration_attributes = configuration_attributes
      
      # Store the aspect instance
      self.class.aspects[id.to_sym] = self 
    end
    
    #
    # Check if the aspect responds to the method
    #
    def respond_to?(symbol, include_private=false)
  
       old_respond_to?(symbol, include_private) or delegate.respond_to?(symbol, include_private)  
    
    end
    
    #
    # Tries to invoke the method on the delegate
    #
    def method_missing(method, *args, &block)
    
      if delegate.respond_to?(method)
        return delegate.send(method, *args)
      end
      
      super
    
    end
    
    #
    # Convert the object to json
    #
    def to_json(options={})
    
      {:id => id, :description => description, :applies_to => applies_to}.to_json(options)
    
    end
    
    #
    # Get the configuration attribute instance which defines the attribute
    #
    # @return
    #   An instance of ::Plugins::Aspect::ConfigurationAttribute 
    #
    def get_configuration_attribute(configuration_attribute_id)
    
      (configuration_attributes.select { |a_c_a| a_c_a.id == configuration_attribute_id }).first
    
    end
    
    #
    # Get the aspect instance
    #
    def self.get(id)
      
      return aspects[id.to_sym]
               
    end
        
    private
    
    #
    # Retrieve the registered aspects
    #
    def self.aspects
      
      return @@aspects
      
    end
    
  end #Aspect

end #Model