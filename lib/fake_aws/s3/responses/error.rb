require 'finer_struct'

module FakeAWS
  module S3
    module Responses

      # S3 error information, extracted from:
      #
      # http://docs.aws.amazon.com/AmazonS3/latest/API/ErrorResponses.html
      class Error < FinerStruct::Immutable(:error_code, :description, :status_code)
        NO_SUCH_BUCKET = new(:error_code => "NoSuchBucket", :description => "The specified bucket does not exist.", :status_code => 404)
        NO_SUCH_KEY = new(:error_code => "NoSuchKey", :description => "The specified key does not exist.", :status_code => 404)
      end

    end
  end
end
