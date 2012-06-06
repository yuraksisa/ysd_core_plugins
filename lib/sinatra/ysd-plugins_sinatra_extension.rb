#
# This is a Sinatra extensions which manages the plugin system
#
# HOWTO
#
# Create a init.rb file in any of your plugins, and use the Plugin.register method to
# register the plugin
#
#   Plugins::Plugin.register :my_plugin
#
#     name        'plugin-name'
#     author      'name of the author'
#     description 'description'
#     version     'version'
#     hooker      HookerClass (extends Plugins::ViewListener)
#     sinatra_extension SinatraExtension module
#     sinatra_helper    SinatraHelper module
#  
#   end
#
#
#
# Then, when this application extension is registered, the plugins will be initialized
#
module Sinatra
  module YSD
    module PluginExtension
    
      def self.registered(app)
      
        # Adds the helpers to the application      
        app.helpers Plugins::HookCall
      
        # Initializes all the registered plugins
        Plugins::Plugin.plugins.each do |plugin_name, plugin|
          plugin.init(app)
          puts "PLUGIN #{plugin_name} initialized"
        end
      
      end
    end #PluginExtension
  end #YSD
end #Sinatra