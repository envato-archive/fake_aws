require 'spec_helper'

describe FakeAWS::S3::RequestParser do

  context "with a path-style request" do
    subject { described_class.new("s3.amazonaws.com", "/mah-bucket/mah-object.txt") }

    it "extracts the bucket" do
      expect(subject.bucket).to eq("mah-bucket")
    end

    it "extracts the key" do
      expect(subject.key).to eq("/mah-object.txt")
    end
  end

  context "with a virtual hosted-style request" do
    subject { described_class.new("mah-bucket.s3.amazonaws.com", "/mah-object.txt") }

    it "extracts the bucket" do
      expect(subject.bucket).to eq("mah-bucket")
    end

    it "extracts the key" do
      expect(subject.key).to eq("/mah-object.txt")
    end
  end

  context "with a CNAME-style request" do
    subject { described_class.new("mah-bucket.mah-domain.com", "/mah-object.txt") }

    it "extracts the bucket" do
      expect(subject.bucket).to eq("mah-bucket.mah-domain.com")
    end

    it "extracts the key" do
      expect(subject.key).to eq("/mah-object.txt")
    end
  end

end
