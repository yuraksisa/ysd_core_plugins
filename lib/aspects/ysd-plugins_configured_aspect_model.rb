require 'data_mapper' unless defined?DataMapper
require 'ysd-plugins_aspect_configuration' unless defined?Plugins::AspectConfiguration

module Plugins
  #
  # Represents the aspects that have been set up for the model
  #
  class ConfiguredModelAspect
    include DataMapper::Resource
    include Plugins::AspectConfiguration
    
    storage_names[:default] = 'plugins_model_aspects'
    
    property :target_model, String, :field => 'model', :length => 50, :key => true    # The model
    property :aspect, String, :field => 'aspect', :length => 32, :key => true         # The aspect

    #
    # Gets the variable name which stores the param value for the entity/aspect
    #
    def get_variable_name(attribute_id)
     
      "aspect.#{aspect}.#{target_model}.#{attribute_id}"
     
    end
    
    #
    # Gets the module name
    #
    def get_module_name
    
      return :core_plugins
    
    end

    #
    # Generates the json
    #
    def as_json(options={})

      methods = options[:methods] || []
      methods << :aspect_attributes

      options[:methods] = methods
      
      super(options)

    end    
        
  end #ConfiguredModelAspect
end #Plugins