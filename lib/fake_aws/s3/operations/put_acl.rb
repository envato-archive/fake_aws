module FakeAWS
  module S3

    module Operations

      class SetACL
        def initialize(root_directory, request)
          @root_directory = root_directory
          @request        = request
        end

        def call
          return no_such_bucket_response unless bucket_on_disk.exists?

          if object_on_disk.exists?
            success_response
          else
            no_such_key_response
          end
        end

      private

        def success_response
          Responses::Empty.new
        end

        def no_such_bucket_response
          Responses::Error.new("NoSuchBucket", "BucketName" => @request.bucket)
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

        def object_on_disk
          @object_on_disk ||= ObjectOnDisk.new(bucket_on_disk, @request.key)
        end

        def bucket_on_disk
          @bucket_on_disk ||= BucketOnDisk.new(@root_directory, @request.bucket)
        end

        def no_such_key_response
          Responses::Error.new("NoSuchKey", "Resource" => @request.key)
        end
      end

    end
  end
end
