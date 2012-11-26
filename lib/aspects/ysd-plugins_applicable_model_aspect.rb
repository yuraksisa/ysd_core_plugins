module Plugins
  #
  # Allows to tag a class to which the aspects can be applied
  # 
  # To allow extending a class using aspects you only have to extend your model with this module
  # 
  # see Plugins::Aspect for more information
  #
  module ApplicableModelAspect
    
    #
    # When an class is extended by this class, the model is registered
    #  
    def self.extended(model)
      ::Plugins::ModelAspect.register_model(model)
    end
    
    #
    # The target model to store in db
    #
    def target_model
      self.name.split('::').last.downcase
    end
   
    # ------------- Aspects management ----------------

    #
    # Return the model applicable aspects
    #
    # @return [Array] of Plugin::Aspect
    #
    def applicable_aspects
    
      Plugins::Aspect.all.select do |aspect| 
      
        Plugins::ModelAspect.aspects_applicable(self).include?(aspect.model_aspect)
      
      end

    end

    #
    # Get the enabled/configured aspects 
    #
    # @return [Array] array of Plugins::AspectConfiguration
    #
    def aspects
      
      if not @aspects
        @aspects = ConfiguredModelAspect.all(:target_model => target_model, :order => [:weight.asc] )
      end
      
      @aspects
      
    end

    #
    # Get a concrete aspects associated with the resource (::Model::EntityAspect)
    #
    # @return [Plugins::AspectConfiguration]
    #
    def aspect(aspect)
      
      (aspects.select { |model_aspect| model_aspect.aspect == aspect }).first
      
    end

    #
    # Assign aspects to the model
    #
    def assign_aspects(assigned_aspects)
        
        the_assigned_aspects = assigned_aspects.map { |model_aspect| model_aspect['aspect']  }
        
        remove_aspects = ConfiguredModelAspect.all(:target_model => target_model, 
                                                   :aspect.not => the_assigned_aspects )
         
        # remove not existing aspects
        if remove_aspects
          remove_aspects.destroy      
        end
        
        # add new aspects
        assigned_aspects.each do |model_aspect|
          if not ConfiguredModelAspect.get(model_aspect['aspect'], model_aspect['target_model'])
            ConfiguredModelAspect.create(model_aspect)
          end
        end
            
        @aspects = ConfiguredModelAspect.all(:target_model => target_model, :order => [:weight.asc] )
    
    end    


  
  end
end