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
                
         call_hooks_text = Plugins::Plugin.plugin_invoke_all(hook, context.merge(:app => self)).join
         
         if (String.method_defined?(:force_encoding))
           call_hooks_text.force_encoding('utf-8') 
         end
         
         call_hooks_text
         
      end
    
  end #HookCall
end #Plugins