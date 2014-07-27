module FakeAWS
  module S3

    # Extract the bucket and key from the various different styles of S3 request.
    #
    # See http://docs.aws.amazon.com/AmazonS3/latest/dev/VirtualHosting.html
    class Request
      def initialize(env)
        @env = env
        @server_name = env["SERVER_NAME"]
        @path_info   = env["PATH_INFO"]
      end

      def method
        @env["REQUEST_METHOD"]
      end

      def content_type
        @env["CONTENT_TYPE"]
      end

      def content
        @env["rack.input"].read
      end

      def http_headers
        http_headers = env_headers.map {|key, value| [header_key_for_env_key(key), value] }
        Hash[http_headers]
      end

      def bucket
        @bucket ||= case request_style
          when :path
            path_components.first
          when :virtual_hosted
            server_name_components[0..-4].join(".")
          when :cname
            @server_name
          else
            raise "Uh oh"
        end
      end

      def key
        @key ||= "/" + case request_style
          when :path
            path_components.drop(1).join("/")
          when :virtual_hosted, :cname
            path_components.join("/")
          else
            raise "Uh oh"
        end
      end

      def has_key?
        key != "/"
      end

    private

      def server_name
        @server_name ||= @env["SERVER_NAME"]
      end

      def path_info
        @path_info ||= @env["PATH_INFO"]
      end

      def server_name_components
        @server_name_components ||= server_name.split(".")
      end

      def path_components
        @path_components ||= path_info.split("/").drop(1)
      end

      def request_style
        @request_style ||= if server_name =~ %r{s3[-\w\d]*\.amazonaws\.com$}
          if server_name_components.length > 3
            :virtual_hosted
          else
            :path
          end
        else
          :cname
        end
      end

      def env_headers
        @env.select {|key, _| key.start_with?("HTTP_") }
      end

      def header_key_for_env_key(env_key)
        env_key.sub(/^HTTP_/, "").gsub("_", "-").downcase
      end

    end

  end
end
