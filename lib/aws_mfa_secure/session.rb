require "aws-sdk-core"
require "fileutils"
require "json"
require "memoist"
require "time"

module AwsMfaSecure
  class Session
    extend Memoist

    def initialize(options={}, *argv)
      @options = options
      @argv = ["aws"] + argv
      @aws_profile = ENV['AWS_PROFILE'] || 'default'
    end

    def run
      if fetch_creds?
        resp = get_session_token
        save_creds(resp.credentials.to_h)
      end

      ENV['AWS_ACCESS_KEY_ID']     = credentials["access_key_id"]
      ENV['AWS_SECRET_ACCESS_KEY'] = credentials["secret_access_key"]
      ENV['AWS_SESSION_TOKEN']     = credentials["session_token"]
      exec(*@argv)
    end

    def fetch_creds?
      mfa_serial && !good_session_creds?
    end

    def good_session_creds?
      return false unless File.exist?(session_creds_path)

      expiration = Time.parse(credentials["expiration"])
      Time.now.utc < expiration # not expired
    end

    def credentials
      JSON.load(IO.read(session_creds_path))
    end
    memoize :credentials

    def save_creds(credentials)
      FileUtils.mkdir_p(File.dirname(session_creds_path))
      IO.write(session_creds_path, JSON.pretty_generate(credentials))
    end

    def session_creds_path
      "#{ENV['HOME']}/.aws/aws-mfa-secure-sessions/#{@aws_profile}"
    end

    def get_session_token
      retries = 0
      begin
        print "Please provide your MFA code: "
        token_code = $stdin.gets.strip
        sts.get_session_token(
          # duration_seconds: 3600,
          serial_number: mfa_serial,
          token_code: token_code,
        )
      rescue Aws::STS::Errors::ValidationError, Aws::STS::Errors::AccessDenied => e
        puts "#{e.class}: #{e.message}"
        puts "Incorrect MFA code.  Please try again."
        retries += 1
        if retries >= 3
          puts "Giving up after #{retries} retries."
          exit 1
        end
        retry
      end
    end

    def mfa_serial
      mfa_serial = sh("aws configure get mfa_serial")
      return mfa_serial unless mfa_serial.empty?
    end
    memoize :mfa_serial

    def sts
      Aws::STS::Client.new
    end
    memoize :sts

    def sh(command)
      `#{command}`.strip
    end
  end
end
