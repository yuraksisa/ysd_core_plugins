require 'dm-core' 

module Plugins
  #
  # It represents the aspect configuration for an entity (it means that the aspect has been configured for the entity)
  #
  # It's a module which can be included in any class which manages aspects to get/hold the aspect configuration
  # which is stored in the SystemConfiguration module
  #
  # This module uses the following methods which have to be defined
  #
  #   aspect:            Returns the aspect identifier
  #   get_variable_name: Returns the variable which will store the aspect attribute configuration
  #   get_module_name:   The module which to which it belongs
  #   
  #
  module AspectConfiguration
  
    def self.included(model)

      if model.respond_to?(:property)

        model.property :weight, Integer, :field => 'weight', :default => 0                      # The weight allows to configure the order of the aspects
        model.property :in_group, DataMapper::Property::Boolean, :field => 'in_group', :default => true               # The aspect information is shown in a group    
        model.property :show_on_new, DataMapper::Property::Boolean, :field => 'show_on_new', :default => true         # Show the aspect on a new operation
        model.property :show_on_edit, DataMapper::Property::Boolean, :field => 'show_on_edit', :default => true       # Show the aspect on an edit operation
        model.property :show_on_view, DataMapper::Property::Boolean, :field => 'show_on_view', :default => true       # Show the aspect on a view operation
        model.property :render_weight, Integer, :field => 'render_weight', :default => 0        # The weight in the render
        model.property :render_in_group, DataMapper::Property::Boolean, :field => 'render_in_group', :default => true # The aspect information is shown in a group

      end

    end

    #
    # Gets the aspect
    #
    def get_aspect(context={})
      
      Plugins::Aspect.get(aspect)
     
    end    
    
    #
    # Gets the param value
    #
    def get_aspect_attribute_value(attribute_id)
      
      default_value = nil
      
      if the_aspect = get_aspect 
        if aspect_configuration_attribute = the_aspect.get_configuration_attribute(attribute_id.to_sym)
          default_value = aspect_configuration_attribute.default_value 
        end
      end
      
      attribute_value = ::SystemConfiguration::Variable.get_value(get_variable_name(attribute_id)) || default_value
        
    end
    
    #
    # Sets the para value
    #
    def set_aspect_attribute_value(attribute_id, value)
      
      if the_aspect = get_aspect
        if configuration_attribute = the_aspect.get_configuration_attribute(attribute_id.to_sym)
          if configuration_attribute.check_value(value)
            if variable = ::SystemConfiguration::Variable.get(get_variable_name(attribute_id))
              variable.value = value
              variable.save
            else
              variable = ::SystemConfiguration::Variable.create( {:name => get_variable_name(attribute_id), 
                                                                  :value => value, 
                                                                  :description => configuration_attribute.description, 
                                                                  :module => get_module_name}) 
            end
          else
           #puts "SETTING ASPECT ATTRIBUTE : INVALID VALUE #{attribute_id} #{value}"
           # invalid value
          end
        else
          # configuration attribute does not exist 
          #puts "SETTING ASPECT ATTRIBUTE : ATTRIBUTE DOES NOT EXIST #{attribute_id} #{value}"
        end
      else
        # there is no aspect
        #puts "SETTING ASPECT ATTRIBUTE : ASPECT DOES NOT EXIST #{attribute_id} #{value}" 
      end
    
    end  

    #
    # Get all the aspects attributes
    # 
    # @return [Hash] of attributes
    #
    def aspect_attributes

      aspect_attributes = {}
      
      if the_aspect = get_aspect
        the_aspect.configuration_attributes.each do |aspect_config_attr|
           aspect_attributes.store(aspect_config_attr.id, 
                                   get_aspect_attribute_value(aspect_config_attr.id))
        end
      end
      
      return aspect_attributes

    end

    #
    # Assign the aspects attributes from a hash
    #
    def aspect_attributes=(options={})
     
      options.each do |attribute_id, value|

        set_aspect_attribute_value(attribute_id, value)

      end

    end
      
  end
end