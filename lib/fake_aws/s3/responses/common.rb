module FakeAWS
  module S3
    module Responses

      # Useful things for generating responses to S3 requests.
      module Common

        # Headers which should be included in all S3 responses.
        def common_headers
          {
            "Date"         => Time.now.httpdate,
            "Server"       => "AmazonS3"
          }
        end

        def to_rack_response
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
