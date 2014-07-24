module FakeAWS
  module S3

    class RackApp
      def initialize(directory)
        @directory = directory
      end

      def call(env)
        operation_for(env).call.to_rack_response
      end

    private

      def operation_for(env)
        operation_class(env).new(@directory, env)
      end

      def operation_class(env)
        request_parser = RequestParser.new(env["SERVER_NAME"], env["PATH_INFO"])

        case env["REQUEST_METHOD"]
          when "PUT"
            if request_parser.has_key?
              Operations::PutObject
            else
              Operations::PutBucket
            end
          when "GET"
            Operations::GetObject
          else
            raise FakeAWS::UnsupportedRequestError # TODO: This needs a spec.
        end
      end

    end

  end
end
