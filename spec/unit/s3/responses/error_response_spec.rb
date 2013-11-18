require 'spec_helper'
require 'nori'

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

  it "has the right status code" do
    expect(subject.status_code).to eq(error.status_code)
  end

  it "has a content type of XML" do
    expect(subject.headers["Content-Type"]).to eq("application/xml")
  end

  it "has a Date header" do
    time = Time.parse("2013-11-18 17:45")
    Time.stub(:now => time)
    expect(subject.headers["Date"]).to eq(time.httpdate)
  end

  it "has a Server header" do
    expect(subject.headers["Server"]).to eq("AmazonS3")
  end

  context "body" do
    let(:parser)      { Nori.new(:parser => :rexml) }
    let(:parsed_body) { parser.parse(subject.body) }

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


