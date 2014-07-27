require 'spec_helper'

describe FakeAWS::S3::Request do
  subject { described_class.new(env) }

  context "#method" do
    it "works"
  end

  context "#content_type" do
    it "works"
  end

  context "#content" do
    it "works"
  end

  context "#http_headers" do
    it "works"
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
