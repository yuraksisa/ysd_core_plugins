module Sinatra
  module YSD
    #
    # Rest API for aspects
    #
    module AspectRESTApi
    
      def self.registered(app)
        
        #
        # Retrieves the aspects which applies to the concrete appliance
        #
        app.get "/aspects/:type" do
        
          aspect_type = params[:type]
          
          aspects = Plugins::Plugin.plugin_invoke_all('aspects', {:app => self}) #.select do |aspect|
            #          aspect.applies_to.include?(aspect_type)
            #        end
          
          puts "aspects : #{aspects}"
                    
           status 200
           content_type :json
           aspects.to_json
        
        end
      
      
      end
    
    end #AspectRESTApi
  end #YSD
end #Sinatra