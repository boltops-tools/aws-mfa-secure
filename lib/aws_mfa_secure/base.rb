require "aws-sdk-core"
require "aws_config"
require "json"
require "memoist"
require "time"

module AwsMfaSecure
  class MfaError < StandardError; end

  class Base
    extend Memoist

    def iam_mfa?
      return true if aws_mfa_env_set?
      return false unless aws_cli_installed? && aws_cli_setup?
      return false unless mfa_serial

      # The iam_mfa? check will only return true for the case when mfa_serial is set and access keys are used.
      # This is because for assume role cases, the current aws cli tool supports mfa_serial already.
      # Sending session AWS based access keys intefere with the current aws cli assume role mfa_serial support
      aws_access_key_id = aws_config(:aws_access_key_id)
      aws_secret_access_key = aws_config(:aws_secret_access_key)
      source_profile = aws_config(:source_profile)

      aws_access_key_id && aws_secret_access_key && !source_profile
    end

    def aws_mfa_env_set?
      ENV['AWS_ACCESS_KEY_ID'] &&
      ENV['AWS_SECRET_ACCESS_KEY'] &&
      ENV['AWS_MFA_SERIAL']
    end

    def aws_cli_installed?
      return false unless File.exist?("#{ENV['HOME']}/.aws")
      system("type aws > /dev/null 2>&1")
    end

    def aws_cli_setup?
      File.exist?("#{ENV['HOME']}/.aws/config") &&
      File.exist?("#{ENV['HOME']}/.aws/credentials")
    end

    def fetch_creds?
      !good_session_creds?
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
      flush_cache # Clear memo cache. Not needed for brand new temp credentials, but needed when updating existing ones
    end

    def session_creds_path
      "#{SESSIONS_PATH}/#{@aws_profile}"
    end

    def get_session_token(shell: false)
      retries = 0
      begin
        token_code = mfa_prompt
        options = {
          serial_number: mfa_serial,
          token_code: token_code,
        }
        options[:duration_seconds] = ENV['AWS_MFA_TTL'] if ENV['AWS_MFA_TTL']

        if shell
          shell_get_session_token(options) # mimic ruby sdk
        else # ruby sdk
          sts.get_session_token(options)
        end
      rescue Aws::STS::Errors::ValidationError, Aws::STS::Errors::AccessDenied, MfaError => e
        $stderr.puts "#{e.class}: #{e.message}"
        $stderr.puts "Incorrect MFA code.  Please try again."
        retries += 1
        if retries >= 3
          $stderr.puts "Giving up after #{retries} retries."
          exit 1
        end
        retry
      end
    end

    def mfa_prompt
      if ENV['AWS_MFA_TOKEN']
        token_code = ENV.delete('AWS_MFA_TOKEN') # only use once, prompt afterwards if incorrect
        return token_code
      end

      $stderr.print "Please provide your MFA code: "
      $stdin.gets.strip
    end

    # Credentials class uses this version of get-session-token to allow the AWS Ruby SDK itself to be patched.
    def shell_get_session_token(options)
      args = options.map { |k,v| "--#{k.to_s.gsub('_','-')} #{v}" }.join(' ')
      command = "aws sts get-session-token #{args} 2>&1"
      # puts "=> #{command}" # uncomment for debugging
      out = `#{command}`

      unless out.include?("Credentials")
        raise(MfaError, out.strip) # custom error
      end

      data = JSON.load(out)
      resp = data.deep_transform_keys { |k| k.underscore }
      # mimic ruby sdk resp
      credentials = Aws::STS::Types::Credentials.new(resp["credentials"])
      Aws::STS::Types::GetSessionTokenResponse.new(credentials: credentials)
    end

    def mfa_serial
      ENV['AWS_MFA_SERIAL'] || aws_config(:mfa_serial)
    end

    def sts
      Aws::STS::Client.new
    end
    memoize :sts

    def aws_config(prop)
      profile_data = AWSConfig[aws_profile]
      return unless profile_data
      v = profile_data[prop.to_s]
      v unless v.blank?
    end
    memoize :aws_config

    def aws_profile
      ENV['AWS_PROFILE'] || 'default'
    end
  end
end
