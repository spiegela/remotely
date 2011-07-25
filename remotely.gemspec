# -*- encoding: utf-8 -*-
require File.expand_path('../lib/remotely/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Matte Noble"]
  gem.email         = ["me@mattenoble.com"]
  gem.description   = %q{Remote API based model associations.}
  gem.summary       = %q{Remote API based model associations.}
  gem.homepage      = ''

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "remotely"
  gem.require_paths = ['lib']
  gem.version       = Remotely::VERSION

  gem.add_development_dependency "rspec", "~> 2.6.0"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "ruby-debug19"
  gem.add_development_dependency "ruby-debug-completion"

  gem.add_dependency "activesupport"
  gem.add_dependency "i18n" # ActiveSupport needs it
  gem.add_dependency "faraday"
  gem.add_dependency "yajl-ruby"
end
