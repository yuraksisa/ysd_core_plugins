<h1>YSD_CORE_PLUGINS</h1>

<p>The ysd_core_plugins gem defines a way to extend "any" of your modules or gems.</p>
<p>Following some simple rules, you will have an engine which can be used to extend your applications or gems.</p>

<h2>1. Extension engine</h2>

  <p>The core plugin brings you a hook system that can be used to extend your gems.</p>
  <p>Moreover, you can automatically register sinatra extensions and helpers. This way you application will look cleaner.</p>

<h2>2. The plugin API</h2>
   
  The plugin system is made of the following components:

  <ul>
    <li>Plugins::Plugin</li>
    <li>Plugins::Aspect</li>
  </ul>

<h3>2.1 Plugin definition</h3>

  <p>The Plugins::Plugin class which lets us to define a plugin. </p>
  
  <p>A plugin defines the following properties:</p>
    
  <ul>
     <li>id</li>
     <li>name</li>
     <li>author</li>
     <li>description</li>
     <li>version</li>
     <li>settings</li>
  </ul>
    
  <p>It also allow to declare the hook classes which can extend other modules. You can do it in the plugin registration.</p>
            
  <p>The method Plugin.register allows registering a new plugin. It receives two parameters, the plugin id and a block which is used to define the plugin.</p>

    <p>The Plugins::SinatraAppPlugin, is a Plugin subclass which lets us define sinatra extensions and helpers.</p>  
      
<h3>2.2 The hooks and/or extensions definitions.</h3>     
      
<h3>2.3 The Aspect class</h3>
  
<h2>3. Using the plugin system in your application</h2>
    
  <p>To use the plugin system in your sinatra application, you only have to register it extension. All of the registered plugins will be initialized when
  the extension is registered.</p>
  
  <pre>
    class MySinatraApp < Sinatra::Base
    
      register Sinatra::YSD::PluginExtension
      helper Plugins::HookCall     
    
    end
  </pre>    
