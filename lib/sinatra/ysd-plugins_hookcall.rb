module Plugins
  #
  # This is a Sinatra helper
  #
  module HookCall
    
      #
      # Calls a hook
      # 
      # @param [Symbol] hook
      #   The hook to invoke
      #
      # @param [Hash] context
      #   The context
      #
      def call_hook( hook, context={})
         
         #return_value = ""
              
         #Plugins::Plugin.plugins.each do |plugin_name, plugin|
         #  
         #  plugin.hooker_instances.each do |hooker_instance|
         #    if hooker_instance.class.method_defined?(hook)
         #      return_value << hooker_instance.send(hook, context.merge(:app => self))
         #    end
         #  end
         #  
         #end
         #         
         #return_value
       
         Plugins::Plugin.plugin_invoke_all(hook, context.merge(:app => self)).join 
       
      end
    
  end #HookCall
end #Plugins