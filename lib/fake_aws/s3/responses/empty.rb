module FakeAWS
  module S3
    module Responses

      class Empty < Rack::Response
        include Common

        def initialize
          super([], 200, common_headers)
        end
      end

    end
  end
end


