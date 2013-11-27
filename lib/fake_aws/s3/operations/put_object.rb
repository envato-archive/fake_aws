module FakeAWS
  module S3

    module Operations

      class PutObject
        def initialize(root_directory, env)
          @root_directory = root_directory
          @env            = env
        end

        def call
          return no_such_bucket_response unless object_store.bucket_exists?

          object_store.write_object(content, metadata)
          success_response
        end

      private

        extend Forwardable

        def success_response
          Responses::Empty.new
        end

        def no_such_bucket_response
          Responses::Error.new("NoSuchBucket", "BucketName" => object_store.bucket)
        end

        def content
          @env["rack.input"].read
        end

        def metadata
          @metadata ||= [content_type_metadata, user_metadata].inject(:merge)
        end

        def content_type_metadata
          { "Content-Type" => @env["CONTENT_TYPE"] }
        end

        def user_metadata
          http_headers.select {|key, _| key.start_with?("x-amz-meta-") }
        end

        def_delegator :env_helper, :http_headers

        def env_helper
          @env_helper ||= EnvHelper.new(@env)
        end

        def object_store
          @object_store ||= ObjectStore.new(@root_directory, @env["SERVER_NAME"], @env["PATH_INFO"])
        end

      end

    end
  end
end
