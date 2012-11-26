module Plugins
  #
  # It represents an aspect configuration attribute definition.
  #
  # An aspect can have configuration attributes which can be configured for 
  # the entity to which the aspect is configured
  #
  # An aspect configuration attribute has an id, a description, a default value and a rule which can be applied to ensure it accepts the value
  #
  class AspectConfigurationAttribute
  
    attr_reader :id, :description, :default_value, :rule
    
    #
    # @param [String] id
    #  The param identifier
    #
    # @param [Object] default_value
    #  The default value
    #
    # @param [Regexp] rule
    #   The rule 
    #
    def initialize(id, description, default_value=nil, rule=nil)
      @id = id
      @description = description
      @default_value = default_value
      @rule = rule
    end
  
    #
    # Check if the value is valid
    #
    def check_value(value)
      id_valid = if rule
        rule.match(value)
      else
        true
      end
    end
  
  end
end