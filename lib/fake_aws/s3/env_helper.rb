module FakeAWS
  module S3

    # Useful tools for extracting information from a Rack env.
    class EnvHelper
      def initialize(env)
        @env = env
      end

      def http_headers
        http_headers = env_headers.map {|key, value| [header_key_for_env_key(key), value] }
        Hash[http_headers]
      end

    private

      def env_headers
        @env.select {|key, _| key.start_with?("HTTP_") }
      end

      def header_key_for_env_key(env_key)
        env_key.sub(/^HTTP_/, "").gsub("_", "-").downcase
      end
    end

  end
end
