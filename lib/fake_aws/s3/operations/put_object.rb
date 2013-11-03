module FakeAWS
  module S3
    module Operations

      class PutObject
        def initialize(directory)
          @directory = directory
        end

        def handle_put(env)
          path_components = env['PATH_INFO'].split("/")
          _, bucket, *directories, file_name = path_components


          if Dir.exists?(File.join(@directory, bucket))
            FileUtils.mkdir_p(File.join(@directory, bucket, *directories))

            full_path = File.join(@directory, env['PATH_INFO'])
            IO.write(full_path, env["rack.input"].read)

            metadata_storage = MetadataStorage.new(full_path)
            metadata_storage.write_metadata(generate_metadata(env))

            [
              200,
              {'Content-Type' => 'application/xml'},
              ["hello world"]
            ]
          else
            [
              404,
              { "Content-Type" => "application/xml" },
              generate_xml_response("NoSuchBucket", "The specified bucket does not exist.", "/#{bucket}")
            ]
          end
        end

      private

        def generate_metadata(env)
          metadata = {
            "Content-Type" => env['CONTENT_TYPE']
          }

          user_metadata_env_keys = env.keys.select {|key| key =~ /^HTTP_X_AMZ_META_/ }
          user_metadata_env_keys.each do |env_key|
            metadata_key = env_key.sub(/^HTTP_/, "").gsub("_", "-").downcase
            metadata[metadata_key] = env[env_key]
          end

          metadata
        end

        def generate_xml_response(code, message, resource)
          # TODO: Fill out the bits of the XML response that we haven't yet.
          <<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<Error>
  <Code>#{code}</Code>
  <Message>#{message}</Message>
  <Resource>#{resource}</Resource>
  <RequestId></RequestId>
</Error>
          EOF
        end

      end

    end
  end
end
