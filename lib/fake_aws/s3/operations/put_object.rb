require 'fake_aws/s3/xml_error_response'

module FakeAWS
  module S3
    module Operations

      class PutObject
        def initialize(directory, env)
          @directory = directory
          @env       = env

          path_components = @env['PATH_INFO'].split("/")
          _, @bucket, *@directories, @file_name = path_components
        end

        def call
          if Dir.exists?(bucket_path)
            write_data
            success_response
          else
            no_such_bucket_response
          end
        end

      private

        def write_data
          make_enclosing_directory
          write_file
          write_metadata
        end

        def make_enclosing_directory
          FileUtils.mkdir_p(directory_path)
        end

        def write_file
          File.write(file_path, file_contents)
        end

        def write_metadata
          metadata_storage.write_metadata(metadata)
        end

        def success_response
          [
            200,
            {'Content-Type' => 'application/xml'},
            ["hello world"]
          ]
        end

        def no_such_bucket_response
          [
            404,
            { "Content-Type" => "application/xml" },
            XMLErrorResponse.new("NoSuchBucket", "The specified bucket does not exist.", "/#{bucket}")
          ]
        end

        def file_contents
          @env["rack.input"].read
        end

        def bucket_path
          @bucket_path ||= File.join(@directory, bucket)
        end

        def directory_path
          @directory_path ||= File.join(@directory, bucket, *directories)
        end

        def file_path
          @file_path ||= File.join(@directory, @env['PATH_INFO'])
        end

        def metadata_storage
          @metadata_storage ||= MetadataStorage.new(file_path)
        end

        def metadata
          @metadata ||= {}.tap do |metadata|
            metadata["Content-Type"] = @env['CONTENT_TYPE']

            user_metadata_env_keys = @env.keys.select {|key| key =~ /^HTTP_X_AMZ_META_/ }
            user_metadata_env_keys.each do |env_key|
              metadata_key = env_key.sub(/^HTTP_/, "").gsub("_", "-").downcase
              metadata[metadata_key] = @env[env_key]
            end
          end
        end

        attr_reader :bucket, :directories, :file_name

      end

    end
  end
end
