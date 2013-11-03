require 'fake_aws/s3/metadata_storage'

describe FakeAWS::S3::MetadataStorage do

  let(:tmp_directory) { "tmp" }
  let(:file_path) { File.join(tmp_directory, "mah-file.txt") }

  subject { described_class.new(file_path) }

  before do
    FileUtils.rm_r(tmp_directory) rescue Errno::ENOENT
    FileUtils.mkdir(tmp_directory)
  end

  describe "#metadata_file_path" do
    it "returns the path to the metadata file for a file" do
      expect(subject.metadata_file_path).to eq("tmp/mah-file.txt.metadata.json")
    end
  end

  describe "#read_metadata" do
    it "returns an empty hash if there's no metadata file" do
      expect(subject.read_metadata).to eq({})
    end

    it "returns the JSON from the metadata file converted to a hash" do
      File.write(subject.metadata_file_path, '{"bunnies":"scary"}')

      expect(subject.read_metadata).to eq("bunnies" => "scary")
    end
  end

  describe "#write_metadata" do
    it "writes the metadata to the metadata file as JSON" do
      subject.write_metadata("bunnies" => "scary")

      expect(File.read(subject.metadata_file_path)).to eq('{"bunnies":"scary"}')
    end
  end

end
