require 'securerandom'

module FakeAWS
  module S3
    module Responses

      # Useful things for generating responses to S3 requests.
      module Common

        # Headers which should be included in all S3 responses.
        def common_headers
          {
            "Date"             => Time.now.httpdate,
            "Server"           => "AmazonS3",
            "x-amz-request-id" => request_id
          }
        end

        def to_rack_response
          [
            status_code,
            headers,
            body
          ]
        end

      protected

        def request_id
          @request_id ||= SecureRandom.hex(8)
        end

      end

    end
  end
end
