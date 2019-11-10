module AwsMfaSecure
  class Clean
    def initialize(options)
      @options = options
    end

    def run
      FileUtils.rm_rf(SESSIONS_PATH)
      puts "Removed #{SESSIONS_PATH}"
    end
  end
end
