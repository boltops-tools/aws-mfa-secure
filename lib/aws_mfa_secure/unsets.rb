module AwsMfaSecure
  class Unsets < Base
    def initialize(options={})
      @options = options
    end

    def run
      puts script
    end

    def script
      <<~EOL
        unset AWS_ACCESS_KEY_ID
        unset AWS_SECRET_ACCESS_KEY
        unset AWS_SESSION_TOKEN
      EOL
    end
  end
end
