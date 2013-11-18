require 'finer_struct'

module FakeAWS
  module S3

    module Operations

      class PutObject
        def initialize(root_directory, env)
          @root_directory = root_directory
          @env            = env
        end

        def call
          # TODO: Bit of a tell-don't-ask violation here. Can it be fixed?
          if object_store.bucket_exists?
            object_store.write_object(content, metadata)
            success_response
          else
            no_such_bucket_response
          end
        end

      private

        def success_response
          Responses::EmptyResponse.new
        end

        def no_such_bucket_response
          Responses::ErrorResponse.new(
            Responses::Error::NO_SUCH_BUCKET,
            "/#{object_store.bucket}"
          )
        end

        def content
          @env["rack.input"].read
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

        def object_store
          @object_store ||= ObjectStore.new(@root_directory, @env["SERVER_NAME"], @env["PATH_INFO"])
        end

      end

    end
  end
end
