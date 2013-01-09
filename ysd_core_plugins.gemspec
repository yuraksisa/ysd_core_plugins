Gem::Specification.new do |s|
  s.name    = "ysd_core_plugins"
  s.version = "0.2.11"
  s.authors = ["Yurak Sisa Dream"]
  s.date    = "2012-02-09"
  s.email   = ["yurak.sisa.dream@gmail.com"]
  s.files   = Dir['lib/**/*.rb']
  s.summary = "Plugins manager"
  s.homepage = "http://github.com/yuraksisa/ysd_core_plugins"
  
  s.add_runtime_dependency "data_mapper", "1.2.0"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "sinatra","~>1.3"
  
  s.add_runtime_dependency "ysd_md_configuration"  #aspects configuration

  
end