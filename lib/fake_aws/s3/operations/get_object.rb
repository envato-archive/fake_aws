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
          Responses::Success.new(content_type, object_store.read_object)
        end

        def no_such_key_response
          Responses::Error.new("NoSuchKey", object_store.key)
        end

        def content_type
          metadata["Content-Type"] || "application/octet-stream"
        end

        def metadata
          @metadata ||= object_store.read_metadata
        end

        def object_store
          @object_store ||= ObjectStore.new(@root_directory, @env["SERVER_NAME"], @env["PATH_INFO"])
        end
      end

    end
  end
end
