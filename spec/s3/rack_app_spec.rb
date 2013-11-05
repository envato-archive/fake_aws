require 'spec_helper'
require 'faraday'
require 'rack/test'
require 'json'

describe FakeAWS::S3::RackApp do
  let(:s3_path)       { "tmp" }
  let(:bucket)        { "mah-bucket" }
  let(:file_name)     { "mah-file.txt"}
  let(:file_contents) { "Hello, world!" }
  subject { described_class.new(s3_path) }

  let(:connection) do
    Faraday.new do |connection|
      connection.adapter :rack, subject
    end
  end

  before do
    FileUtils.rm_r(s3_path) rescue Errno::ENOENT
    FileUtils.mkdir(s3_path)
  end

  context "PUT object" do
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

  context "GET object" do
    def get_example_file(key)
      connection.get(File.join(bucket, key))
    end

    context "with a file that exists" do
      before do
        FileUtils.mkdir(File.join(s3_path, bucket))
        File.write(File.join(s3_path, bucket, file_name), file_contents)
      end

      it "returns a 200" do
        response = get_example_file(file_name)
        expect(response.status).to eq(200)
      end

      it "returns a correctly constructed response"

      it "returns the contents of the file" do
        response = get_example_file(file_name)
        expect(response.body).to eq(file_contents)
      end

      it "returns the right content type" do
        file_metadata = {
          "Content-Type" => "text/plain"
        }.to_json
        File.write(File.join(s3_path, bucket, "#{file_name}.metadata.json"), file_metadata)

        response = get_example_file(file_name)
        expect(response.headers["Content-Type"]).to eq("text/plain")
      end
    end

    context "with a file that doesn't exist" do
      before do
        FileUtils.mkdir(File.join(s3_path, bucket))
      end

      it "returns a 404" do
        response = get_example_file(file_name)
        expect(response.status).to eq(404)
      end

      it "returns the correct XML response"
    end

    context "with a bucket that doesn't exist" do
      it "returns the right sort of error" do
        pending "Need to figure out what error AWS actually returns for this case"
      end
    end
  end

end

