module AwsMfaSecure
  class Exports < Base
    def initialize(options={})
      @options = options
      @aws_profile = aws_profile
    end

    def run
      if fetch_creds?
        resp = get_session_token
        save_creds(resp.credentials.to_h)
      end

      puts script
    end

    def script
      <<~EOL
        export AWS_ACCESS_KEY_ID=#{credentials["access_key_id"]}
        export AWS_SECRET_ACCESS_KEY=#{credentials["secret_access_key"]}
        export AWS_SESSION_TOKEN=#{credentials["session_token"]}
      EOL
    end
  end
end
