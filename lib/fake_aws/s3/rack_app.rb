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


        if Dir.exists?(File.join(@directory, bucket))
          FileUtils.mkdir_p(File.join(@directory, bucket, *directories))

          full_path = File.join(@directory, env['PATH_INFO'])
          IO.write(full_path, env["rack.input"].read)

          [
            200,
            {'Content-Type' => 'text/plain'},
            ["hello world"]
          ]
        else
          [
            404,
            { "Content-Type" => "application/xml" },
            generate_xml_response("NoSuchBucket", "The specified bucket does not exist.", "/#{bucket}")
          ]
        end
      end

      def handle_get(env)
        full_path = File.join(@directory, env['PATH_INFO'])

        if File.exists?(full_path)
          [
            200,
            { "Content-Type" => "text/plain" },
            File.new(File.join(@directory, env["PATH_INFO"]))
          ]
        else
          # TODO: Fill out the bits of the XML response that we haven't yet.
          [
            404,
            { "Content-Type" => "application/xml" },
            # TODO: need to figure out what the resource should be here.
            generate_xml_response("NoSuchKey", "The specified key does not exist.", "")
          ]
        end
      end

    private

      def generate_xml_response(code, message, resource)
        # TODO: Fill out the bits of the XML response that we haven't yet.
        <<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<Error>
  <Code>#{code}</Code>
  <Message>#{message}</Message>
  <Resource>#{resource}</Resource>
  <RequestId></RequestId>
</Error>
        EOF
      end

    end

  end
end
