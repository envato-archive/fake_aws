module FakeAWS
  module S3
    module Operations

      class GetObject
        def initialize(directory)
          @directory = directory
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
          metadata_storage = MetadataStorage.new(file_path)
          metadata = metadata_storage.read_metadata
          metadata["Content-Type"] || "application/octet-stream"
        end

      end

    end
  end
end
