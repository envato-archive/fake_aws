require 'json'

module FakeAWS
  module S3

    # Read and write S3 objects and metadata about them in the filesystem.
    class ObjectStore

      def initialize(root_directory, path_info)
        @root_directory = root_directory
        @path_info = path_info

        path_components = @path_info.split("/")
        _, @bucket, *@directories, @file_name = path_components
      end

      attr_reader :bucket

      def bucket_exists?
        Dir.exists?(bucket_path)
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
        @bucket_path ||= File.join(@root_directory, @bucket)
      end

      def file_path
        @file_path ||= File.join(@root_directory, @path_info)
      end

      def metadata_file_path
        "#{file_path}.metadata.json"
      end

      def directory_path
        @directory_path ||= File.join(@root_directory, @bucket, *@directories)
      end

    end

  end
end
