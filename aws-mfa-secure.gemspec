# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "aws_mfa_secure/version"

Gem::Specification.new do |spec|
  spec.name          = "aws-mfa-secure"
  spec.version       = AwsMfaSecure::VERSION
  spec.authors       = ["Tung Nguyen"]
  spec.email         = ["tongueroo@gmail.com"]
  spec.summary       = "Generated with cli-template tool. Please write a gem summary"
  spec.description   = "Generated with cli-template tool. Write a longer description or delete this line."
  spec.homepage      = ""
  spec.license       = ""

  spec.files         = `git ls-files`.split($/)
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "rainbow"
  spec.add_dependency "thor"
  spec.add_dependency "zeitwerk"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "cli_markdown"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if gem.respond_to?(:metadata)
    # gem.metadata["allowed_push_host"] = ""

    gem.metadata["homepage_uri"] = gem.homepage
    gem.metadata["source_code_uri"] = ""
    gem.metadata["changelog_uri"] = ""
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end
end
