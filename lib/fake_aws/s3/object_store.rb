require 'json'

module FakeAWS
  module S3

    # Read and write S3 objects and metadata about them in the filesystem.
    class ObjectStore

      def initialize(root_directory, bucket, key = nil)
        @root_directory = root_directory
        @bucket         = bucket
        @key            = key
      end

      attr_reader :bucket, :key

      def bucket_exists?
        Dir.exists?(bucket_path)
      end

      def create_bucket
        FileUtils.mkdir_p(bucket_path)
      end

      def object_exists?
        File.exists?(file_path)
      end

      def write_object(content, metadata)
        FileUtils.mkdir_p(directory_path)
        File.write(file_path, content)
        File.write(metadata_file_path, metadata.to_json)
      end

      def read_object
        File.new(file_path)
      end

      def read_metadata
        if File.exists?(metadata_file_path)
          JSON.parse(File.read(metadata_file_path))
        else
          {}
        end
      end

    private

      def bucket_path
        @bucket_path ||= File.join(@root_directory, bucket)
      end

      def file_path
        @file_path ||= File.join(bucket_path, key)
      end

      def metadata_file_path
        @metadata_file_path ||= "#{file_path}.metadata.json"
      end

      def directory_path
        @directory_path ||= File.join(@root_directory, bucket, File.dirname(key))
      end

    end

  end
end
