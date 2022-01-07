$:.unshift(File.expand_path("../", __FILE__))
require "aws_mfa_secure/version"
require "active_support"
require "active_support/core_ext/hash"
require "active_support/core_ext/string"
require "fileutils"
require "rainbow/ext/string"

require "aws_mfa_secure/autoloader"
AwsMfaSecure::Autoloader.setup

module AwsMfaSecure
  SESSIONS_PATH = "#{ENV['HOME']}/.aws/aws-mfa-secure-sessions"
  class Error < StandardError; end
end

root = File.expand_path("../", __dir__)
require "#{root}/spec/monkey_patches" if ENV['AWS_MFA_SECURE_TEST']
