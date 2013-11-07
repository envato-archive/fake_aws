require 'spec_helper'

describe "S3 PUT Object operation" do
  include S3IntegrationSpecHelpers

  let(:bucket)        { "mah-bucket" }
  let(:file_name)     { "mah-file.txt"}
  let(:file_contents) { "Hello, world!" }

  def put_example_file(key)
    connection.put do |request|
      request.url(File.join(bucket, key))
      request.headers["Content-Type"] = "text/plain"
      request.headers["x-amz-meta-example"] = "example metadata"
      request.body = file_contents
    end
  end

  def read_example_metadata(key)
    metadata_file_path = File.join(s3_path, "/#{bucket}/#{key}.metadata.json")
    JSON.parse(File.read(metadata_file_path))
  end

  context "with an existing bucket" do
    before do
      Dir.mkdir(File.join(s3_path, bucket))
    end

    it "returns a 200" do
      response = put_example_file(file_name)
      expect(response.status).to eq(200)
    end

    it "returns a correctly constructed response"

    it "creates a file" do
      put_example_file(file_name)
      expect(File.read(File.join(s3_path, "/#{bucket}/#{file_name}"))).to eq(file_contents)
    end

    it "stores the content-type" do
      put_example_file(file_name)

      metadata = read_example_metadata(file_name)
      expect(metadata["Content-Type"]).to eq("text/plain")
    end

    it "stores user-defined metadata" do
      put_example_file(file_name)

      metadata = read_example_metadata(file_name)
      expect(metadata["x-amz-meta-example"]).to eq("example metadata")
    end

    it "creates sub-directories for paths that contain them" do
      put_example_file("foo/bar/#{file_name}")
      expect(File.read(File.join(s3_path, "/#{bucket}/foo/bar/#{file_name}"))).to eq(file_contents)
    end

    it "handles sub-directories that already exist" do
      FileUtils.mkdir_p(File.join(s3_path, "#{bucket}/foo/bar"))
      put_example_file("foo/bar/#{file_name}")
      expect(File.read(File.join(s3_path, "/#{bucket}/foo/bar/#{file_name}"))).to eq(file_contents)
    end
  end

  context "without an existing bucket" do
    it "returns a 404" do
      response = put_example_file(file_name)
      expect(response.status).to eq(404)
    end

    it "returns the correct XML response"
  end

end

