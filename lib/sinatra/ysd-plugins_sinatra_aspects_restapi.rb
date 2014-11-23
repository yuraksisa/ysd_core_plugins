require 'aspects/ysd-plugins_model_aspect'
module Sinatra
  module YSD
    #
    # Rest API for aspects
    #
    module AspectRESTApi
    
      def self.registered(app)
        
        #
        # Retrieves the aspects which can be applied to the type
        #
        app.get "/api/aspects/:type" do
 
          aspects = []

          if model = (Plugins::ModelAspect.registered_models.select {|m| m.target_model == params[:type]}).first
            aspects = model.applicable_aspects
            aspects.sort! {|a,b| a.id <=> b.id}
          end

          status 200
          content_type :json
          aspects.to_json
        
        end
      
      
      end
    
    end #AspectRESTApi
  end #YSD
end #Sinatra