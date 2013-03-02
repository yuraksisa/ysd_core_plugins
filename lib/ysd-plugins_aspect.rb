module Plugins
  # 
  # <h2>What is an aspect</h2>
  #
  # Aspects are "plugable" characteristics and behaviour which can be applied to an object to improve its abilities.
  #
  # Instead of define this functionality for all your models, you can define it in an aspect, and set it up when
  # necessary.
  #
  # Examples of Aspects are attachments management, photo clips, address definition, ... 
  #
  # <h2>Basic concepts</h2>
  #
  # An aspect implies an object extension. This extension is achieve in two ways: 
  # 
  #  - The model
  #  - The gui (front end)
  #
  # For example, to manage prices, add a new field in the model (price) and show a widget to manage it on the gui.
  #
  # These concepts are represented by the following classes:
  #
  #  <ul>
  #    <li>Plugins::ModelAspect</li>
  #    <li>Plugins::ApplicableModelAspect</li>
  #    <li>Plugins::Aspect</li>
  #  </ul> 
  #
  # <h2>How to</h2>
  # 
  # <ol>
  #   <li>Tag your aspects model including the Plugins::ModelAspect<li>
  #   <li>Tag your models to which aspects are applicable, extending Plugins::ApplicableModelAspect</li>
  #   <li>Define which aspects are applicable to which models</li>
  #   <li>Apply the aspects</li>
  # </old>
  #
  # An aspect model is not directly applied to all the applicable model aspects. It has to be done in your code
  #
  # To define which aspects are applicable to which models, use the aspect_applicable method of Plugins::ModelAspect
  #
  #   <pre>
  #     Plugins::ModelAspect.aspect_applicable(FieldSet::Hobbies, Users::Profile)
  #   </pre> 
  # 
  # To apply the aspects model to the models, use the apply method of Plugins::ModelAspect
  #
  #   <pre>
  #     Plugins::ModelAspect.apply
  #   </pre>
  #
  # <h2>Aspects definition</h2>
  #
  # The extensions define their aspects in the aspects method
  #
  #  def aspects(context={})
  #    
  #    app = context[:app]
  #    
  #    aspects = []
  #    aspects << ::Plugins::Aspect.new(:my_aspect, 'aspect description', [:entity], MyAspectDelegate.new)
  #                                             
  #    return aspects
  #     
  #  end     
  #
  # <h2>Aspect configuration</h2>
  #
  # An aspect can define configuration attributes, which can be individually configured for any of
  # the models to which the aspect is applied
  #  
  #
  # <h2>Retrieving the aspects</h2>
  #
  # In the application, the configured aspects can be retrieved using
  #
  #  Plugins::Plugin.plugin_invoke_all('aspects')
  #
  #
  class Aspect
    
    attr_reader :id, :description, :model_aspect, :gui_block, :configuration_attributes
    
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
    # @param [ModelAspect] model aspect
    #  Reference to the model aspect
    #
    # @param [Object] gui_block
    #  The guiblock responsible of render the aspect in the gui 
    #
    # @param [Array] configuration
    #   An array of AspectConfiguration with the default configuration attributes
    #
    def initialize(id, description, model_aspect, gui_block, configuration_attributes=[])
      
      @id = id
      @description = description
      @model_aspect = model_aspect   
      @gui_block = gui_block
      @configuration_attributes = configuration_attributes
      
      self.class.aspects[id.to_sym] = self 
    
    end
    
    #
    # Check if the aspects affects the render processs
    #
    def affects_render?

      return gui_block.respond_to?(:custom)

    end

    #
    # Check if the aspect affects the edit process
    #
    def affects_edit?
      
      return gui_block.respond_to?(:element_form)

    end

    #
    # Check if the aspect responds to the method
    #
    def respond_to?(symbol, include_private=false)
  
       old_respond_to?(symbol, include_private) or gui_block.respond_to?(symbol, include_private)  
    
    end
    
    #
    # Tries to invoke the method on the delegate
    #
    def method_missing(method, *args, &block)
    
      if gui_block.respond_to?(method)
        return gui_block.send(method, *args)
      end
      
      super
    
    end
    
    #
    # Convert the object to json
    #
    def to_json(options={})
    
      {:id => id, 
       :description => description,
       :affects_edit => affects_edit?, 
       :affects_render => affects_render?, 
       :configuration_attributes => Hash[configuration_attributes.map{|configuration_attribute| [configuration_attribute.id, configuration_attribute.default_value]}] 
       }.to_json(options)
    
    end
    
    #
    # Get the definition of the configuration attribute 
    #
    # @return
    #   An instance of ::Plugins::Aspect::ConfigurationAttribute 
    #
    def get_configuration_attribute(configuration_attribute_id)
    
      (configuration_attributes.select { |aspect_configuration_attribute| aspect_configuration_attribute.id == configuration_attribute_id }).first
    
    end
    
    #
    # Get an aspect instance by its id
    #
    def self.get(id)
      
      return aspects[id.to_sym]
               
    end

    #
    # Get all the aspects
    #
    def self.all
      return aspects.values
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