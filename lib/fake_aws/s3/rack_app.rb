require 'fake_aws/s3/operations/get_object'
require 'fake_aws/s3/operations/put_object'

module FakeAWS
  module S3

    class RackApp
      def initialize(directory)
        @directory = directory
      end

      def call(env)
        case env["REQUEST_METHOD"]
          when "PUT"
            Operations::PutObject.new(@directory).handle_put(env)
          when "GET"
            Operations::GetObject.new(@directory).handle_get(env)
          else
            raise "Unhandled request method"  # TODO: Make an proper exception for this.
        end
      end
    end

  end
end
