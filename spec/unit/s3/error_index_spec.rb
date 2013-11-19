require 'spec_helper'

describe FakeAWS::S3::ErrorIndex do

  context ".error_for_code" do
    it "returns something containing a description and status code for a known error" do
      error = subject.error_for_code("NoSuchKey")
      expect(error.description).to eq("The specified key does not exist.")
      expect(error.status_code).to eq(404)
    end

    it "blows up if given an unknown error code" do
      expect { subject.error_for_code("NotARealCode") }.to raise_error(FakeAWS::UnknownResponseErrorCode)
    end
  end

end
