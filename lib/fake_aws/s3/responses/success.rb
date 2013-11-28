module FakeAWS
  module S3
    module Responses

      class Success
        include Common

        def initialize(headers, body)
          @headers = headers
          @body    = body
        end

        def status_code
          200
        end

        def headers
          common_headers.merge(@headers)
        end

        def body
          @body
        end
      end

    end
  end
end



