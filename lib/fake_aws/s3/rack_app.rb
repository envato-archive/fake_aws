module FakeAWS
  module S3

    class RackApp
      def initialize(directory)
        @directory = directory
      end

      def call(env)
        request = Request.new(env)
        operation_for(request).call
      end

    private

      def operation_for(request)
        operation_class(request).new(@directory, request)
      end

      def operation_class(request)
        case
          when request.put?
            get_put_operation_class(request)
          when request.get?
            Operations::GetObject
          else
            raise FakeAWS::UnsupportedRequestError
        end
      end

      def get_put_operation_class(request)
        case
          when request.has_key?
           Operations::PutObject
          else
            Operations::PutBucket
        end
      end

    end

  end
end
