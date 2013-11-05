require 'fake_aws/s3/xml_error_response'
require 'fake_aws/s3/object_store'

module FakeAWS
  module S3
    module Operations

      class GetObject
        def initialize(root_directory, env)
          @root_directory = root_directory
          @env            = env
        end

        def call
          if object_store.object_exists?
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
            object_store.read_object
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

        def content_type
          metadata["Content-Type"] || "application/octet-stream"
        end

        def metadata
          @metadata ||= object_store.read_metadata
        end

        def object_store
          @object_store ||= ObjectStore.new(@root_directory, @env["PATH_INFO"])
        end
      end

    end
  end
end
