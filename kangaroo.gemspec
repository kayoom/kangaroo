Gem::Specification.new do |s|
  s.name        = "kangaroo"
  s.version     = "0.0.1.alpha"
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.authors     = ["Michael Eickenberg", "Marian Theisen"]
  s.email       = 'marian@cice-online.net'
  s.summary     = "Kang! ActiveResource OpenObject"
  s.homepage    = "http://github.com/cice/kangARoo"
  s.description = "ActiveResource OpenObject Wrapper"

  s.files        =  Dir["**/*"] -
                    Dir["coverage/**/*"] -
                    Dir["rdoc/**/*"] -
                    Dir["doc/**/*"] -
                    Dir["sdoc/**/*"] -
                    Dir["rcov/**/*"]

  s.add_dependency "activeresource", ">= 3.0.0"
  s.add_dependency "activesupport", ">= 3.0.0"
end