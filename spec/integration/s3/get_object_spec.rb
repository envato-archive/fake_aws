require 'spec_helper'

describe "S3 GET Object operation" do
  include S3IntegrationHelpers
  include XMLParsingHelper

  let(:bucket)        { "mah-bucket" }
  let(:file_name)     { "mah-file.txt"}
  let(:file_contents) { "Hello, world!" }

  def get_example_file(key)
    connection.get(File.join(bucket, key))
  end

  context "with a file that exists" do
    before do
      FileUtils.mkdir(File.join(s3_path, bucket))
      File.write(File.join(s3_path, bucket, file_name), file_contents)
    end

    it "returns a successful response" do
      response = get_example_file(file_name)
      expect(response.status).to eq(200)
    end

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

    it "returns a NoSuchKey error" do
      response = get_example_file(file_name)
      expect(response.status).to eq(404)
      expect(parse_xml(response.body)["Error"]["Code"]).to eq("NoSuchKey")
    end

    it "returns the key as the resource" do
      response = get_example_file(file_name)
      expect(parse_xml(response.body)["Error"]["Resource"]).to eq("/#{file_name}")
    end
  end

  context "with a bucket that doesn't exist" do
    it "returns the right sort of error" do
      pending "Need to figure out what error AWS actually returns for this case"
    end
  end

end
