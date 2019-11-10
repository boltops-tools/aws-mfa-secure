require "aws-sdk-core"
require "aws_mfa_secure"

module AwsMfaCredentials
  def initialize(*)
    credentials = AwsMfaSecure::Credentials.instance
    if credentials.set?
      @access_key_id = credentials.access_key_id
      @secret_access_key = credentials.secret_access_key
      @session_token = credentials.session_token
    else
      super
    end
  end
end

module Aws
  class Credentials
    prepend AwsMfaCredentials
  end
end
