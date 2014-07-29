require 'spec_helper'

describe FakeAWS::S3::Request do
  subject { described_class.new(env) }

  context "#method" do
    it "returns the request method" do
      request = described_class.new("REQUEST_METHOD" => "GET")
      expect(request.method).to eq("GET")
    end
  end

  context "#content_type" do
    it "returns the content type" do
      request = described_class.new("CONTENT_TYPE" => "text/plain")
      expect(request.content_type).to eq("text/plain")
    end
  end

  context "#content" do
    it "reads and returns the Rack input" do
      rack_input = double("rack.input")
      expect(rack_input).to receive(:read) { "foo" }
      request = described_class.new("rack.input" => rack_input)
      expect(request.content).to eq("foo")
    end
  end

  context "#http_headers" do
    it "returns the HTTP headers" do
      request = described_class.new("HTTP_X_FOO" => "foo", "HTTP_X_BAR" => "bar")
      expect(request.http_headers).to eq("x-foo" => "foo", "x-bar" => "bar")
    end

    it "ignores non-HTTP headers" do
      request = described_class.new("FOO" => "foo")
      expect(request.http_headers).to eq({})
    end
  end

  context "with a path-style request" do
    let(:env) do
      { "SERVER_NAME" => "s3.amazonaws.com", "PATH_INFO" => "/mah-bucket/mah-object.txt" }
    end

    it "extracts the bucket" do
      expect(subject.bucket).to eq("mah-bucket")
    end

    it "extracts the key" do
      expect(subject.key).to eq("/mah-object.txt")
    end
  end

  context "with a virtual hosted-style request" do
    let(:env) do
      { "SERVER_NAME" => "mah-bucket.s3.amazonaws.com", "PATH_INFO" => "/mah-object.txt" }
    end

    it "extracts the bucket" do
      expect(subject.bucket).to eq("mah-bucket")
    end

    it "extracts the key" do
      expect(subject.key).to eq("/mah-object.txt")
    end

    it "has a key" do
      expect(subject.has_key?).to be_truthy
    end
  end

  context "with a CNAME-style request" do
    let(:env) do
      { "SERVER_NAME" => "mah-bucket.mah-domain.com", "PATH_INFO" => "/mah-object.txt" }
    end

    it "extracts the bucket" do
      expect(subject.bucket).to eq("mah-bucket.mah-domain.com")
    end

    it "extracts the key" do
      expect(subject.key).to eq("/mah-object.txt")
    end
  end

  context "with just a bucket" do
    let(:env) do
      { "SERVER_NAME" => "s3.amazonaws.com", "PATH_INFO" => "/mah-bucket" }
    end

    it "extracts the bucket" do
      expect(subject.bucket).to eq("mah-bucket")
    end

    it "doesn't have a key" do
      expect(subject.has_key?).to be_falsy
    end
  end

end
