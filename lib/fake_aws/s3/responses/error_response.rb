module FakeAWS
  module S3
    module Responses

      class ErrorResponse
        include Common

        def initialize(error, resource)
          @error = error
          @resource = resource
        end

        def status_code
          @error.status_code
        end

        def headers
          common_headers.merge("Content-Type" => "application/xml")
        end

        def body
          "".tap do |xml|
            xml << %q{<?xml version="1.0" encoding="UTF-8"?>\n}
            xml << %q{<Error>}

            xml << "  <Code>#{@error.error_code}</Code>"
            xml << "  <Message>#{@error.description}</Message>"
            xml << "  <Resource>#{@resource}</Resource>"
            xml << "  <RequestId></RequestId>"

            xml << %q{</Error>}
          end
        end
      end

    end
  end
end

