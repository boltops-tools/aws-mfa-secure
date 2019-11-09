describe AwsMfaSecure::CLI do
  describe "aws-mfa-secure" do
    it "exports" do
      out = execute("exe/aws-mfa-secure exports")
      expect(out).to include("AWS_ACCESS_KEY_ID")
    end

    it "unsets" do
      out = execute("exe/aws-mfa-secure unsets")
      expect(out).to include("AWS_ACCESS_KEY_ID")
    end

    it "session" do
      out = execute("exe/aws-mfa-secure session --version 2>&1")
      expect(out).to include("aws-cli")
    end
  end
end
