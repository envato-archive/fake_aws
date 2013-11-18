module FakeAWS
  module S3
    module Responses

      module Common
        def common_headers
          {
            "Date"         => Time.now.httpdate,
            "Server"       => "AmazonS3"
          }
        end

        def to_a
          [
            status_code,
            headers,
            body
          ]
        end
      end

    end
  end
end
