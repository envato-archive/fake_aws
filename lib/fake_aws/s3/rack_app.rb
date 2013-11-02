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

          metadata_file_path = "#{full_path}.metadata.json"
          IO.write(metadata_file_path, 
            {"Content-Type" => env['CONTENT_TYPE']}.to_json)

          [
            200,
            {'Content-Type' => 'application/xml'},
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
            { "Content-Type" => get_content_type(full_path) },
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

      def get_content_type(file_path)
        get_metadata(file_path, "Content-Type") || "application/octet-stream"
      end

      def get_metadata(file_path, key)
        metadata_file_path = "#{file_path}.metadata.json"
        metadata = if File.exists?(metadata_file_path)
          JSON.parse(File.read(metadata_file_path))
        else
          {}
        end
        metadata[key]
      end
    end

  end
end
