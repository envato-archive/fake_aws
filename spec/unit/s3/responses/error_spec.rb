require 'spec_helper'

describe FakeAWS::S3::Responses::Error do

  # Stub out looking up the error information:
  let(:error_code)  { "NoSuchKey" }
  let(:error)       { double(:description => "The specified key does not exist.", :status_code => 404) }
  let(:error_index) { double(:error_for_code => error) }
  before            { stub_const("FakeAWS::S3::ErrorIndex", error_index) }

  let(:resource) { "/mah-bucket/mah-object.txt" }

  subject { described_class.new(error_code, "Resource" => resource) }

  include_examples "common response headers"

  it "has the right status code" do
    expect(subject.status_code).to eq(error.status_code)
  end

  it "has a content type of XML" do
    expect(subject.headers["Content-Type"]).to eq("application/xml")
  end

  context "body" do
    include XMLParsingHelper

    let(:parsed_body) { parse_xml(subject.body) }

    it "contains the right code" do
      expect(parsed_body["Error"]["Code"]).to eq(error_code)
    end

    it "contains the right message" do
      expect(parsed_body["Error"]["Message"]).to eq(error.description)
    end

    it "contains any additional fields passed in" do
      expect(parsed_body["Error"]["Resource"]).to eq(resource)
    end

    it "contains the right request ID" do
      expect(parsed_body["Error"]["RequestId"]).to eq(subject.headers["x-amz-request-id"])
    end
  end

end


