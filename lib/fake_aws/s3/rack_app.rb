module FakeAWS
  module S3

    class RackApp
      def initialize(directory)
        @directory = directory
      end

      def call(env)
        request = Request.new(env)
        operation_for(request).call.to_rack_response
      end

    private

      def operation_for(request)
        operation_class(request).new(@directory, request)
      end

      def operation_class(request)
        case request.method
          when "PUT"
            if request.has_key?
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
