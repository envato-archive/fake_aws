require 'spec_helper'

describe "Request styles:" do
  include S3IntegrationHelpers

  let(:bucket)        { "mah-bucket" }
  let(:file_name)     { "mah-file.txt"}
  let(:file_contents) { "Hello, world!" }

  before do
    FileUtils.mkdir(File.join(s3_path, bucket))
    File.write(File.join(s3_path, bucket, file_name), file_contents)
  end

  shared_examples "GET Object" do
    it "returns a 200" do
      response = get_example_file(file_name)
      expect(response.status).to eq(200)
    end

    it "returns the contents of the file" do
      response = get_example_file(file_name)
      expect(response.body).to eq(file_contents)
    end
  end

  context "path-style GET Object" do
    def get_example_file(key)
      connection.get("http://s3.amazonaws.com/#{bucket}/#{key}")
    end

    include_examples "GET Object"
  end

  context "virtual hosted-style GET Object" do
    def get_example_file(key)
      connection.get("http://#{bucket}.s3.amazonaws.com/#{key}")
    end

    include_examples "GET Object"
  end

  context "CNAME-style GET Object" do
    let(:bucket) { "mah-bucket.mah-domain.com" }

    def get_example_file(key)
      connection.get("http://#{bucket}/#{key}")
    end

    include_examples "GET Object"
  end

end

