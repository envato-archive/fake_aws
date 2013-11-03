require 'fake_aws/s3/xml_error_response'

module FakeAWS
  module S3
    module Operations

      class GetObject
        def initialize(directory, env)
          @directory = directory
          @env       = env
        end

        def call
          if File.exists?(file_path)
            success_response
          else
            no_such_key_response
          end
        end

      private

        def success_response
          [
            200,
            { "Content-Type" => content_type },
            File.new(file_path)
          ]
        end

        def no_such_key_response
          [
            404,
            { "Content-Type" => "application/xml" },
            # TODO: need to figure out what the resource should be here.
            XMLErrorResponse.new("NoSuchKey", "The specified key does not exist.", "")
          ]
        end

        def file_path
          @file_path ||= File.join(@directory, @env['PATH_INFO'])
        end

        def content_type
          metadata["Content-Type"] || "application/octet-stream"
        end

        def metadata
          @metadata ||= metadata_storage.read_metadata
        end

        def metadata_storage
          @metadata_storage ||= MetadataStorage.new(file_path)
        end

      end

    end
  end
end
