module FakeAWS
  module S3
    module Responses

      class Empty
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


