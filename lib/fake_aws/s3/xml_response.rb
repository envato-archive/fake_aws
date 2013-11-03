module FakeAWS
  module S3

    # TODO: This is a misnomer. It actually only does XML error responses.
    class XMLResponse
      def initialize(code, message, resource)
        @code = code
        @message = message
        @resource = resource
      end

      def to_str
        # TODO: Fill out the bits of the XML response that we haven't yet.
        "".tap do |xml|
          xml << %q{<?xml version="1.0" encoding="UTF-8"?>\n}
          xml << %q{<Error>}

          xml << "  <Code>#{@code}</Code>"
          xml << "  <Message>#{@message}</Message>"
          xml << "  <Resource>#{@resource}</Resource>"
          xml << "  <RequestId></RequestId>"

          xml << %q{</Error>}
        end
      end

    end

  end
end
