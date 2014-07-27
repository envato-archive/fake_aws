module FakeAWS
  module S3
    module Operations

      class GetObject
        def initialize(root_directory, request)
          @root_directory = root_directory
          @request        = request
        end

        def call
          return no_such_bucket_response unless object_store.bucket_exists?
          return no_such_key_response    unless object_store.object_exists?

          success_response
        end

      private

        def success_response
          Responses::Success.new(headers, object_store.read_object)
        end

        def no_such_bucket_response
          Responses::Error.new("NoSuchBucket", "BucketName" => object_store.bucket)
        end

        def no_such_key_response
          Responses::Error.new("NoSuchKey", "Resource" => object_store.key)
        end

        def headers
          [content_type_header, user_headers].inject(:merge)
        end

        def user_headers
          metadata.select {|key, _| key.start_with?("x-amz-meta-") }
        end

        def content_type_header
          { "Content-Type" => metadata["Content-Type"] || "application/octet-stream" }
        end

        def metadata
          @metadata ||= object_store.read_metadata
        end

        def object_store
          @object_store ||= ObjectStore.new(@root_directory, @request.bucket, @request.key)
        end
      end

    end
  end
end
