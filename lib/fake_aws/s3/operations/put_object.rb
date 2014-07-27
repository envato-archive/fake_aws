module FakeAWS
  module S3

    module Operations

      class PutObject
        def initialize(root_directory, request)
          @root_directory = root_directory
          @request        = request
        end

        def call
          return no_such_bucket_response unless object_store.bucket_exists?

          object_store.write_object(@request.content, metadata)
          success_response
        end

      private

        def success_response
          Responses::Empty.new
        end

        def no_such_bucket_response
          Responses::Error.new("NoSuchBucket", "BucketName" => object_store.bucket)
        end

        def metadata
          @metadata ||= [content_type_metadata, user_metadata].inject(:merge)
        end

        def content_type_metadata
          { "Content-Type" => @request.content_type }
        end

        def user_metadata
          @request.http_headers.select {|key, _| key.start_with?("x-amz-meta-") }
        end

        def object_store
          @object_store ||= ObjectStore.new(@root_directory, @request.bucket, @request.key)
        end

      end

    end
  end
end
