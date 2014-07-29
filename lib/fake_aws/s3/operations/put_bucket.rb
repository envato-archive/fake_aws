module FakeAWS
  module S3

    module Operations

      class PutBucket
        def initialize(root_directory, request)
          @root_directory = root_directory
          @request        = request
        end

        def call
          return bucket_already_exists_response if bucket_on_disk.exists?

          bucket_on_disk.create
          success_response
        end

      private

        def success_response
          Responses::Empty.new
        end

        def bucket_already_exists_response
          Responses::Error.new("BucketAlreadyExists", "BucketName" => @request.bucket)
        end

        def bucket_on_disk
          @bucket_on_disk ||= BucketOnDisk.new(@root_directory, @request.bucket)
        end

      end

    end

  end
end
