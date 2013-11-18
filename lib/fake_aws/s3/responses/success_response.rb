module FakeAWS
  module S3
    module Responses

      class SuccessResponse
        include Common

        def initialize(content_type, body)
          @content_type = content_type
          @body         = body
        end

        def status_code
          200
        end

        def headers
          common_headers.merge(
            "Content-Type" => @content_type
          )
        end

        def body
          @body
        end
      end

    end
  end
end



