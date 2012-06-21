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
                
         Plugins::Plugin.plugin_invoke_all(hook, context.merge(:app => self)).join.force_encoding('utf-8') 
       
      end
    
  end #HookCall
end #Plugins