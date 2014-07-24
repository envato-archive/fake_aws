module FakeAWS
  module S3

    module Operations

      class PutBucket
        def initialize(root_directory, env)
          @root_directory = root_directory
          @env            = env
        end

        def call
          return bucket_already_exists_response if object_store.bucket_exists?

          object_store.create_bucket
          success_response
        end

      private

        def success_response
          Responses::Empty.new
        end

        def bucket_already_exists_response
          Responses::Error.new("BucketAlreadyExists", "BucketName" => object_store.bucket)
        end

        def object_store
          @object_store ||= ObjectStore.new(@root_directory, @env["SERVER_NAME"], @env["PATH_INFO"])
        end

      end

    end

  end
end
