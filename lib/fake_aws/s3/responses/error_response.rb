module FakeAWS
  module S3
    module Responses

      class ErrorResponse
        include Common

        def initialize(error_code, resource)
          @error_code = error_code
          @resource = resource
        end

        def status_code
          error.status_code
        end

        def headers
          common_headers.merge("Content-Type" => "application/xml")
        end

        def body
          "".tap do |xml|
            xml << %q{<?xml version="1.0" encoding="UTF-8"?>\n}
            xml << %q{<Error>}

            xml << "  <Code>#{@error_code}</Code>"
            xml << "  <Message>#{error.description}</Message>"
            xml << "  <Resource>#{@resource}</Resource>"
            xml << "  <RequestId></RequestId>"

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

