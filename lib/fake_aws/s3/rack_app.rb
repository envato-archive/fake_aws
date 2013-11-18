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
        response  = operation.call
        response.to_a
      end
    end

  end
end
