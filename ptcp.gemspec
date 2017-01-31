# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ptcp/version'

Gem::Specification.new do |spec|
  spec.name          = "ptcp"
  spec.version       = PTCP::VERSION
  spec.authors       = ["Benedikt Bock"]
  spec.email         = ["mail@benedikt1992.de"]

  spec.summary       = %q{This script translates PuTTy cli calls into Cygwin commands.}
  spec.description   = %q{PuTTy to CygWin Proxy - This script translates PuTTy cli calls into Cygwin commands.}
  spec.homepage      = "https://github.com/Benedikt1992/PTCP"
  spec.license       = "Apache 2.0"
  
  spec.required_ruby_version = '>= 2.2.0'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  spec.add_dependency 'deep_merge'
  spec.add_dependency 'colorize'
  spec.add_dependency 'slop'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "ocra"
end
