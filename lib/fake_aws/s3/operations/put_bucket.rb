module FakeAWS
  module S3

    module Operations

      class PutBucket
        def initialize(root_directory, request)
          @root_directory = root_directory
          @request        = request
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
          @object_store ||= ObjectStore.new(@root_directory, @request.bucket)
        end

      end

    end

  end
end
