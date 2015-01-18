module FakeAWS
  module S3
    module Responses

      class Empty < Rack::Response
        include Common

        def initialize(status = 200, headers = {})
          super([], status, common_headers.merge(headers))
        end
      end

    end
  end
end


