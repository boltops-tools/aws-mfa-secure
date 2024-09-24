require "aws-sdk-core"
require "aws_mfa_secure"

module AwsMfaCredentials
  def initialize(access_key_id, secret_access_key, session_token = nil, **kwargs)
    credentials = AwsMfaSecure::Credentials.instance
    if credentials.set?
      @access_key_id = credentials.access_key_id
      @secret_access_key = credentials.secret_access_key
      @session_token = credentials.session_token
    else
      super(access_key_id, secret_access_key, session_token, **kwargs)
    end
  end
end

module Aws
  class Credentials
    prepend AwsMfaCredentials
  end
end

