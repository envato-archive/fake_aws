module FakeAWS
  module S3
    module Operations

      class GetObject
        def initialize(root_directory, request)
          @root_directory = root_directory
          @request        = request
        end

        def call
          return no_such_bucket_response unless bucket_on_disk.exists?
          return no_such_key_response    unless object_on_disk.exists?

          success_response
        end

      private

        def success_response
          Responses::Success.new(object_on_disk.read_content, 200, headers)
        end

        def no_such_bucket_response
          Responses::Error.new("NoSuchBucket", "BucketName" => @request.bucket)
        end

        def no_such_key_response
          Responses::Error.new("NoSuchKey", "Resource" => @request.key)
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
          @metadata ||= object_on_disk.read_metadata
        end

        def object_on_disk
          @object_on_disk ||= ObjectOnDisk.new(bucket_on_disk, @request.key)
        end

        def bucket_on_disk
          @bucket_on_disk ||= BucketOnDisk.new(@root_directory, @request.bucket)
        end

      end

    end
  end
end
