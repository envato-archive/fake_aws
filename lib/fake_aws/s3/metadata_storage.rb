require 'json'

module FakeAWS
  module S3

    class MetadataStorage
      def initialize(file_path)
        @file_path = file_path
      end

      def metadata_file_path
        "#{@file_path}.metadata.json"
      end

      def read_metadata
        if File.exists?(metadata_file_path)
          JSON.parse(File.read(metadata_file_path))
        else
          {}
        end
      end

      def write_metadata(metadata)
        File.write(metadata_file_path, metadata.to_json)
      end

    end

  end
end
