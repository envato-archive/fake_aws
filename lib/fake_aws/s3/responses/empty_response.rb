module FakeAWS
  module S3
    module Responses

      class EmptyResponse
        include Common

        def status_code
          200
        end

        def headers
          common_headers
        end

        def body
          ""
        end
      end

    end
  end
end


