module FakeAWS
  module S3
    module Responses

      class Error
        include Common

        def initialize(error_code, fields = {})
          @error_code = error_code
          @fields     = fields
        end

        def status_code
          error.status_code
        end

        def headers
          @headers ||= common_headers.merge("Content-Type" => "application/xml")
        end

        def body
          "".tap do |xml|
            xml << %q{<?xml version="1.0" encoding="UTF-8"?>\n}
            xml << %q{<Error>}

            xml << "  <Code>#{@error_code}</Code>"
            xml << "  <Message>#{error.description}</Message>"

            @fields.each_pair do |key, value|
              xml << "  <#{key}>#{value}</#{key}>"
            end

            xml << "  <RequestId>#{request_id}</RequestId>"

            xml << %q{</Error>}
          end
        end

      private

        def error
          @error ||= FakeAWS::S3::ErrorIndex.error_for_code(@error_code)
        end

      end

    end
  end
end

