module Plugins
  #
  # It allows to define an aspect which can be applied to an element to
  # improve their abilities
  #
  #
  class Aspect
    
    attr_reader :id
    attr_reader :description
    attr_reader :applies_to
    attr_reader :delegate
    
    alias old_respond_to? respond_to?
    
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
    #   How does the aspect applies
    #
    def initialize(id, description, applies_to, delegate)
      @id = id
      @description = description
      @applies_to = applies_to   
      @delegate = delegate
    end
    
    #
    # Check if the aspect responds to the method
    #
    def respond_to?(symbol, include_private=false)
      
      puts "respond to #{symbol} #{old_respond_to?(symbol, include_private) or delegate.respond_to?(symbol, include_private)}"
      
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
    
    
  end #Aspect

end #Model