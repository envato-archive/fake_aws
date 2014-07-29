require 'json'

module FakeAWS
  module S3

    class ObjectOnDisk

      def initialize(bucket_on_disk, key = nil)
        @bucket_on_disk = bucket_on_disk
        @key            = key
      end

      def exists?
        File.exists?(object_path)
      end

      def write(content, metadata)
        FileUtils.mkdir_p(directory_path)
        File.write(object_path, content)
        File.write(metadata_path, metadata.to_json)
      end

      def read_content
        File.new(object_path)
      end

      def read_metadata
        if File.exists?(metadata_path)
          JSON.parse(File.read(metadata_path))
        else
          {}
        end
      end

      def object_path
        @object_path ||= File.join(@bucket_on_disk.path, @key)
      end

      def metadata_path
        @metadata_path ||= File.join("#{object_path}.metadata.json")
      end

      def directory_path
        @directory_path ||= File.dirname(object_path)
      end

    end

  end
end
