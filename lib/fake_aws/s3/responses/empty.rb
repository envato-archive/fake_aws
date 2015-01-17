module FakeAWS
  module S3
    module Responses

      class Empty < Rack::Response
        include Common

        def initialize(status = 200, headers = common_headers)
          super([], status, headers)
        end
      end

    end
  end
end


