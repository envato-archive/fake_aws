require 'fake_aws/s3/rack_app'
require 'faraday'
require 'rack/test'

describe FakeAWS::S3::RackApp do
  context "PUT object" do
    let(:s3_path) { "tmp" }
    let(:bucket)  { "mah-bucket" }
    subject { described_class.new(s3_path) }

    let(:connection) do
      connection = Faraday.new do |connection|
        connection.adapter :rack, subject
      end
    end

    after do
      system("rm -rf #{s3_path}/*")  # TODO: Find a rubyish, safer way to do this.
    end

    def put_example_file(key)
      connection.put do |request|
        request.url(File.join(bucket, key))
        request.headers["Content-Type"] = "text/plain"
        request.body = "Hello, world!"
      end
    end

    context "with an existing bucket" do
      before do
        Dir.mkdir(File.join(s3_path, bucket))
      end

      it "returns a 200" do
        response = put_example_file("mah-file.txt")
        expect(response.status).to eq(200)
      end

      it "returns a correctly constructed response"

      it "creates a file" do
        response = put_example_file("mah-file.txt")
        expect(File.read(File.join(s3_path, "/mah-bucket/mah-file.txt"))).to eq("Hello, world!")
      end

      it "creates sub-directories for paths that contain them" do
        response = put_example_file("foo/bar/mah-file.txt")
        expect(File.read(File.join(s3_path, "/mah-bucket/foo/bar/mah-file.txt"))).to eq("Hello, world!")
      end

      it "handles sub-directories that already exist" do
        FileUtils.mkdir_p(File.join(s3_path, "mah-bucket/foo/bar"))
        response = put_example_file("foo/bar/mah-file.txt")
        expect(File.read(File.join(s3_path, "/mah-bucket/foo/bar/mah-file.txt"))).to eq("Hello, world!")
      end
    end

    context "without an existing bucket" do
      it "returns a 404" do
        response = put_example_file("mah-file.txt")
        expect(response.status).to eq(404)
      end

      it "returns the correct XML response"
    end

  end
end

