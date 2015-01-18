module FakeAWS
  module S3
    module Responses

      class Success < Rack::Response
        include Common

        def initialize(body, status, headers = {})
          super body, status, common_headers.merge(headers)
        end
      end

    end
  end
end



