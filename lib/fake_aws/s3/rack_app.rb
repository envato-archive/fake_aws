module FakeAWS
  module S3

    class RackApp
      def initialize(directory)
        @directory = directory
      end

      def call(env)
        case env["REQUEST_METHOD"]
          when "PUT"
            handle_put(env)
          when "GET"
            handle_get(env)
          else
            raise "Unhandled request method"  # TODO: Make an proper exception for this.
        end
      end

      def handle_put(env)
        path_components = env['PATH_INFO'].split("/")
        _, bucket, *directories, file_name = path_components

        unless Dir.exists?(File.join(@directory, bucket))
          return [
            404,
            { "Content-Type" => "application/xml" },
            <<-EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <Error>
      <Code>NoSuchBucket</Code>
      <Message>The specified bucket does not exist.</Message>
      <Resource>/#{bucket}</Resource>
      <RequestId>4442587FB7D0A2F9</RequestId>
    </Error>}
            EOF
          ]
        end

        FileUtils.mkdir_p(File.join(@directory, bucket, *directories))

        full_path = File.join(@directory, env['PATH_INFO'])
        IO.write(full_path, env["rack.input"].read)

        [
          200,
          {'Content-Type' => 'text/plain'},
          ["hello world"]
        ]
      end

      def handle_get(env)
        [
          200,
          { "Content-Type" => "text/plain" },
          File.new(File.join(@directory, env["PATH_INFO"]))
        ]
      end

    end

  end
end
