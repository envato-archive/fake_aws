require 'spec_helper'

describe "Request styles:" do
  include S3IntegrationSpecHelpers

  let(:bucket)        { "mah-bucket" }
  let(:file_name)     { "mah-file.txt"}
  let(:file_contents) { "Hello, world!" }

  before do
    FileUtils.mkdir(File.join(s3_path, bucket))
    File.write(File.join(s3_path, bucket, file_name), file_contents)
  end

  context "virtual hosted-style GET Object" do
    def get_example_file(key)
      connection.get("http://#{bucket}.s3.amazonaws.com/#{key}")
    end

    it "returns a 200" do
      response = get_example_file(file_name)
      expect(response.status).to eq(200)
    end

    it "returns the contents of the file" do
      response = get_example_file(file_name)
      expect(response.body).to eq(file_contents)
    end
  end

  context "CNAME-style GET Object" do
    let(:bucket) { "mah-bucket.mah-domain.com" }

    def get_example_file(key)
      connection.get("http://#{bucket}/#{key}")
    end

    it "returns a 200" do
      response = get_example_file(file_name)
      expect(response.status).to eq(200)
    end

    it "returns the contents of the file" do
      response = get_example_file(file_name)
      expect(response.body).to eq(file_contents)
    end
  end

end

