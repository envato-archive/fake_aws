require 'spec_helper'

describe FakeAWS::S3::Request do
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

  shared_examples "request parsing" do
    context "bucket request" do
      let(:key) { "/" }

      it "extracts the bucket" do
        expect(request.bucket).to eq(bucket)
      end

      it "has no key" do
        expect(request.has_key?).to be_falsy
      end
    end

    context "object request" do
      let(:key) { "/mah-object.txt" }

      it "extracts the bucket" do
        expect(request.bucket).to eq(bucket)
      end

      it "has a key" do
        expect(request.has_key?).to be_truthy
      end

      it "extracts the key" do
        expect(request.key).to eq(key)
      end
    end
  end

  context "path-style" do
    let(:bucket) { "mah-bucket" }
    subject(:request) { described_class.new("SERVER_PORT" => "80", "SERVER_NAME" => "s3.amazonaws.com", "PATH_INFO" => "/#{bucket}#{key}") }

    include_examples "request parsing"
  end

  context "virtual hosted-style" do
    let(:bucket) { "mah-bucket" }
    subject(:request) { described_class.new("SERVER_PORT" => "80", "SERVER_NAME" => "#{bucket}.s3.amazonaws.com", "PATH_INFO" => key) }

    include_examples "request parsing"
  end

  context "CNAME-style" do
    let(:bucket) { "mah-bucket.mah-domain.com" }
    subject(:request) { described_class.new("SERVER_PORT" => "80", "SERVER_NAME" => bucket, "PATH_INFO" => key) }

    include_examples "request parsing"
  end

end
