require 'fake_aws/s3/xml_error_response'

module FakeAWS
  module S3
    module Operations

      class GetObject
        def initialize(directory)
          @directory = directory
        end

        def call(env)
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
              XMLErrorResponse.new("NoSuchKey", "The specified key does not exist.", "")
            ]
          end
        end

      private

        def get_content_type(file_path)
          metadata_storage = MetadataStorage.new(file_path)
          metadata = metadata_storage.read_metadata
          metadata["Content-Type"] || "application/octet-stream"
        end

      end

    end
  end
end
