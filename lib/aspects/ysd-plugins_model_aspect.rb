module Plugins
  # 
  # It allows definying an aspect model. 
  #
  # To define an model aspect, you only have to include this module to the class which implements the aspect
  #
  # see Plugins::Aspect for more information
  #
  # Example:
  #  
  #  module FieldSet
  #
  #    module Telephone
  #      include Plugins::ModelAspect
  #      def self.included(model)
  #        model.property :phone_number, String, :length => 20
  #      end
  #    end
  #
  #  end
  # 
  #  class Customer
  #    property :id, Serial, :key => true
  #    property :name, String, :length => 50
  #  end
  #
  #  ModelAspect.apply_aspects(Customer)
  #
  module ModelAspect
  
    #
    # Retrieves the classes or modules which include this module
    #  
    def self.descendants
      @descendants ||= []
    end 
    
    #
    # Retrieve the models to which the aspects can be applied
    #
    def self.registered_models
      @registered_models ||= []
    end
    
    #
    # Retrieve the models which manage it own aspects
    #
    def self.own_managed_registered_models
      @own_management_registered_models ||= []
    end

    #
    # Retrieve the managed aspects
    #
    def self.managed_registered_models
       p "#{registered_models.inspect}"
       p "#{own_managed_registered_models}"
       registered_models - own_managed_registered_models
    end

    #
    # Register a model
    #
    def self.register_model(model)
      registered_models << model
    end

    #
    # Considers that a model own manages it aspects
    #
    def self.register_own_managed_model(model)
      own_managed_registered_models << model
    end
    
    #
    # Retrieve the applicable aspects
    #
    # @return [Hash] 
    #
    #   The key is the model aspect and the value is a list of the models to which the aspect can be applied
    #
    def self.applicable_aspects
      @applicable_aspects ||= {}
    end
    
    #
    # Retrieve the aspects which can be applied to a model
    #
    def self.aspects_applicable(model)
      
      result = []

      applicable_aspects.each do |aspect, models|
        if models.include?(model)
          result << aspect
        end
      end

      return result

    end

    #
    # When the class is included
    #
    def self.included(descendant)
      descendants << descendant
      applicable_aspects.store(descendant, [])
    end
    
    #
    # Defines that the aspect is applicable to the model
    #
    # @param [Object] aspect
    #   The aspect that can be applied
    #
    # @param [Object] model
    #   The model (class) to which the aspect can be applied
    #
    def self.aspect_applicable(aspect, model)
    
      if applicable_aspects.has_key?(aspect)
        applicable_aspects.fetch(aspect) << model
      end
    
    end
    
    #
    # It allows to apply all the aspects to a model
    #
    def self.apply_all_aspects(model)
      descendants.each do |descendant|
        if applicable_aspects[descendant].include?(model)
          puts "applying #{descendant} to #{model}"
          model.send :include, descendant
        end
      end
    end
    
    #
    # Apply the configured aspects
    #
    def self.apply
      
      applicable_aspects.each do |aspect, models|
         models.each do |model|
           puts "applying #{aspect} to #{model}"
           model.send :include, aspect
         end
      end
    
    end
    
    #
    # It allows to apply some aspects to a model
    #
    def self.apply_aspects(model, aspects)
    
      aspects.each do |aspect|
        if descendants.include?(aspect)
          puts "applying #{aspect} to #{model}"
          model.send :include, aspect
        end
      end
    
    end
    
   
    
  end # ModelAspect
  
end