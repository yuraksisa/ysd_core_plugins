Gem::Specification.new do |s|
  s.name    = "ysd_core_plugins"
  s.version = "0.1"
  s.authors = ["Yurak Sisa Dream"]
  s.date    = "2012-02-09"
  s.email   = ["yurak.sisa.dream@gmail.com"]
  s.files   = Dir['lib/**/*.rb']
  s.summary = "Plugins manager"
  
  s.add_runtime_dependency "ysd_md_logger","0.1"
  s.add_runtime_dependency "ysd_md_configuration"  
  
end