require "singleton"

# Useful for Ruby interfacing
module AwsMfaSecure
  class Credentials < Base
    # Using Singleton as caching mechanism for speed
    # The fetch_creds? is slow from shelling out to python for aws configure get.
    include Singleton

    attr_reader :data
    def initialize
      @aws_profile = aws_profile
      setup
    end

    def setup
      return unless iam_mfa?

      if fetch_creds?
        resp = get_session_token(shell: true)
        save_creds(resp.credentials.to_h)
      end

      @data = credentials
    end

    def set?
      !!@data
    end

    %w[access_key_id secret_access_key session_token].each do |name|
      define_method name do
        @data[name]
      end
    end
  end
end
