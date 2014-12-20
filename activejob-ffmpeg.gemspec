# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_job/ffmpeg/version'

Gem::Specification.new do |spec|
  spec.name          = "activejob-ffmpeg"
  spec.version       = ActiveJob::Ffmpeg::VERSION
  spec.authors       = ["joker1007"]
  spec.email         = ["kakyoin.hierophant@gmail.com"]
  spec.description   = %q{easier way to use ffmpeg in activejob}
  spec.summary       = %q{easier way to use ffmpeg in activejob}
  spec.homepage      = "https://github.com/joker1007/activejob-ffmpeg"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency     "activejob", ">= 4.2.0.rc3"
  spec.add_development_dependency "bundler", ">= 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "tapp"
  spec.add_development_dependency "coveralls"
end
