require 'finer_struct'

module FakeAWS
  module S3
    module Responses

      class Error < FinerStruct::Immutable(:error_code, :description, :status_code)
        NO_SUCH_BUCKET = new(:error_code => "NoSuchBucket", :description => "The specified bucket does not exist.", :status_code => 404)
      end

    end
  end
end
