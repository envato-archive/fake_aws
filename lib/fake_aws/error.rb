module FakeAWS
  class Error < RuntimeError
  end

  class UnknownResponseErrorCode < Error
    def initialize
      super("Attempting to look up an AWS error code that doesn't exist. This is probably a bug in FakeAWS.")
    end
  end

  class UnsupportedRequestError < Error
    def initialize
      super("FakeAWS doesn't (yet) support this type of AWS request.")
    end
  end
end
