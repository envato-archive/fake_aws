require 'spec_helper'

describe FakeAWS::S3::Responses::Success do

  let(:headers) { { "Content-Type" => "text/plain" } }
  let(:body)    { "Hello, world!" }

  subject { described_class.new(body, 200, headers) }

  include_examples "common response headers"

  it "has a status code of 200" do
    expect(subject).to be_ok
  end

  it "has the right body" do
    expect(subject.body.first).to eq(body)
  end

  it "has the right content type" do
    expect(subject.header["Content-Type"]).to eq("text/plain")
  end

end

