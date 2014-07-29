module FakeAWS
  module S3

    class BucketOnDisk

      def initialize(root_directory, bucket)
        @root_directory = root_directory
        @bucket         = bucket
      end

      def exists?
        Dir.exists?(path)
      end

      def create
        FileUtils.mkdir_p(path)
      end

      def path
        @path ||= File.join(@root_directory, @bucket)
      end

    end

  end
end
