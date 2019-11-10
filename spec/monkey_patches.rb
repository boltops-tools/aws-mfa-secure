AwsMfaSecure::Base # autoload
module AwsMfaSecure
  class Base
    def session_creds_path
      root = File.expand_path("../", __dir__)
      "#{root}/spec/fixtures/aws-mfa-secure-sessions/fake_credentials"
    end

    def fetch_creds?
      false
    end

    def iam_mfa?
      true
    end

    def aws_configure_get(*)
      "fake"
    end
  end
end
