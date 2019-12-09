require "zeitwerk"

module AwsMfaSecure
  class Autoloader
    class Inflector < Zeitwerk::Inflector
      def camelize(basename, _abspath)
        map = { cli: "CLI", version: "VERSION" }
        map[basename.to_sym] || super
      end
    end

    class << self
      def setup
        loader = Zeitwerk::Loader.new
        loader.inflector = Inflector.new
        lib = File.dirname(__dir__) # lib
        loader.push_dir(lib)
        loader.ignore("#{lib}/aws-mfa-secure.rb")
        loader.do_not_eager_load("#{lib}/aws_mfa_secure/ext/aws.rb")
        loader.setup
      end
    end
  end
end
