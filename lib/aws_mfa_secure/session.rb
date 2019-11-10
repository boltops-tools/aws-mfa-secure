module AwsMfaSecure
  class Session < Base
    def initialize(options={}, *argv)
      @options = options
      @argv = ["aws"] + argv
      @aws_profile = aws_profile
    end

    def run
      unless iam_mfa?
        exec(*@argv) # will never get pass this point if there's no mfa_serial setting
      end

      if fetch_creds?
        resp = get_session_token(shell: true)
        save_creds(resp.credentials.to_h)
      end

      ENV['AWS_ACCESS_KEY_ID']     = credentials["access_key_id"]
      ENV['AWS_SECRET_ACCESS_KEY'] = credentials["secret_access_key"]
      ENV['AWS_SESSION_TOKEN']     = credentials["session_token"]
      exec(*@argv)
    end
  end
end
