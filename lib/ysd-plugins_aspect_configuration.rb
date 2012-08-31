module Plugins
  #
  # It manages the aspect configuration
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
  
    #
    # Gets the aspect
    #
    def get_aspect
      
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
        else
          puts "GETTING ASPECT ATTRIBUTE : ATTRIBUTE DOES NOT EXIST #{attribute_id}"
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
           puts "SETTING ASPECT ATTRIBUTE : INVALID VALUE #{attribute_id} #{value}"
           # invalid value
          end
        else
          # configuration attribute does not exist 
          puts "SETTING ASPECT ATTRIBUTE : ATTRIBUTE DOES NOT EXIST #{attribute_id} #{value}"
        end
      else
        # there is no aspect
        puts "SETTING ASPECT ATTRIBUTE : ASPECT DOES NOT EXIST #{attribute_id} #{value}" 
      end
    
    end  
  
  
  end
end