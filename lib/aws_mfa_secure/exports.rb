module AwsMfaSecure
  class Exports < Base
    def initialize(options={})
      @options = options
      @aws_profile = aws_profile
    end

    def run
      # Allow use `aws-mfa-secure exports --no-mfa`
      # This bypasses the check for mfa_serial being configured in the ~/.aws/credentials profile
      # Useful if we want to grab temporary AWS_xxx credentials for testing.
      if @options[:mfa] == false
        resp = sts.get_session_token
        puts script(resp.credentials)
        return
      end

      unless iam_mfa?
        $stderr.puts "WARN: mfa_serial is not configured for this AWS_PROFILE=#{@aws_profile}"
        $stderr.puts "If you want to use exports without this mfa_serial check. Use the --no-mfa option."
        return
      end

      if fetch_creds?
        resp = get_session_token
        save_creds(resp.credentials.to_h)
      end

      puts script(credentials)
    end

    def script(creds)
      <<~EOL
        export AWS_ACCESS_KEY_ID=#{creds["access_key_id"]}
        export AWS_SECRET_ACCESS_KEY=#{creds["secret_access_key"]}
        export AWS_SESSION_TOKEN=#{creds["session_token"]}
      EOL
    end
  end
end
