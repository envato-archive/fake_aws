require 'spec_helper'

describe FakeAWS::S3::Responses::SuccessResponse do

  let(:content_type) { "text/plain" }
  let(:body)         { "Hello, world!" }

  subject { described_class.new(content_type, body) }

  it "has a status code of 200" do
    expect(subject.status_code).to eq(200)
  end

  it "has the right body" do
    expect(subject.body).to eq(body)
  end

  it "has the right content type" do
    expect(subject.headers["Content-Type"]).to eq(content_type)
  end

  it "has a Date header" do
    time = Time.parse("2013-11-18 17:45")
    Time.stub(:now => time)
    expect(subject.headers["Date"]).to eq(time.httpdate)
  end

  it "has a Server header" do
    expect(subject.headers["Server"]).to eq("AmazonS3")
  end

end

