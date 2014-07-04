require 'spec_helper'

describe "S3 PUT Bucket operation" do
  include S3IntegrationHelpers
  include XMLParsingHelper

  let(:bucket)      { "mah-bucket" }
  let(:bucket_path) { File.join(s3_path, bucket) }

  def put_bucket
    connection.put do |request|
      request.url("http://#{bucket}.s3.amazonaws.com")
    end
  end

  context "without an existing bucket" do
    it "returns a 200" do
      response = put_bucket
      expect(response.status).to eq(200)
    end

    it "creates the bucket directory on disk" do
      response = put_bucket
      expect(Dir.exist?(bucket_path)).to be_true
    end
  end

  context "with an existing bucket" do
    before do
      Dir.mkdir(bucket_path)
    end

    it "returns a Bucket Already Exists error" do
      response = put_bucket
      expect(response.status).to eq(409)
      expect(parse_xml(response.body)["Error"]["Code"]).to eq("BucketAlreadyExists")
    end
  end

end
