require 'fake_aws/s3/operations/get_object'
require 'fake_aws/s3/operations/put_object'

module FakeAWS
  module S3

    class RackApp
      def initialize(directory)
        @directory = directory
      end

      def call(env)
        operation_class = case env["REQUEST_METHOD"]
          when "PUT"
            Operations::PutObject
          when "GET"
            Operations::GetObject
          else
            raise "Unhandled request method"  # TODO: Make a proper exception for this.
        end

        operation = operation_class.new(@directory, env)
        operation.call
      end
    end

  end
end
