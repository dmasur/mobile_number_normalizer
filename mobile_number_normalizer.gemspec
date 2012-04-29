# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mobile_number_normalizer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dominik Masur"]
  gem.email         = ["dominik.masur@googlemail.com"]
  gem.description   = %q{Normalize mobile Phone Numbers}
  gem.summary       = %q{Normalize mobile Phone Numbers}
  gem.homepage      = "https://github.com/TBAA/mobile_number_normalizer"
  gem.version       = MobileNumberNormalizer::VERSION
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "mobile_number_normalizer"
  gem.require_paths = ["lib"]
  gem.version       = MobileNumberNormalizer::VERSION
  
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "active_support"
end
