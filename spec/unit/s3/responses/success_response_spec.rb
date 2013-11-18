require 'spec_helper'

describe FakeAWS::S3::Responses::SuccessResponse do

  let(:content_type) { "text/plain" }
  let(:body)         { "Hello, world!" }

  subject { described_class.new(content_type, body) }

  include_examples "common response headers"

  it "has a status code of 200" do
    expect(subject.status_code).to eq(200)
  end

  it "has the right body" do
    expect(subject.body).to eq(body)
  end

  it "has the right content type" do
    expect(subject.headers["Content-Type"]).to eq(content_type)
  end

end

