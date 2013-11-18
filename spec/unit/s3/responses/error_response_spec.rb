require 'spec_helper'

describe FakeAWS::S3::Responses::ErrorResponse do

  let(:error) do
    FinerStruct::Immutable.new(
      :error_code  => "NoSuchKey",
      :description => "The specified key does not exist.",
      :status_code => 404
    )
  end
  let(:resource) { "/mah-bucket/mah-object.txt" }

  subject { described_class.new(error, resource) }

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
      expect(parsed_body["Error"]["Code"]).to eq(error.error_code)
    end

    it "contains the right message" do
      expect(parsed_body["Error"]["Message"]).to eq(error.description)
    end

    it "contains the right resource" do
      expect(parsed_body["Error"]["Resource"]).to eq(resource)
    end

    it "contains the right request ID"
  end

end


