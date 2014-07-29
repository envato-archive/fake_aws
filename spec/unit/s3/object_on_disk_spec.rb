require 'spec_helper'

describe FakeAWS::S3::ObjectOnDisk do
  let(:key)            { "/mah-file.txt" }

  let(:bucket_path)    { "tmp/mah-bucket" }
  let(:object_path)    { "#{bucket_path}#{key}" }
  let(:metadata_path)  { "#{object_path}.metadata.json" }

  let(:bucket_on_disk) { double(:path => bucket_path) }

  subject { described_class.new(bucket_on_disk, key) }

  before do
    FileUtils.rm_r(bucket_path) rescue Errno::ENOENT
    FileUtils.mkdir_p(bucket_path)
  end

  describe "#exists?" do
    it "returns true if the object file exists" do
      File.write(object_path, "Hello, world!")
      expect(subject.exists?).to be_truthy
    end

    it "returns false if the object file doesn't exist" do
      expect(subject.exists?).to be_falsy
    end
  end

  describe "#write" do
    it "writes the content to the object file" do
      subject.write("Hello, world!", { "bunnies" => "scary" })

      expect(File.read(object_path)).to eq("Hello, world!")
    end

    it "writes the metadata to the metadata file as JSON" do
      subject.write("Hello, world!", { "bunnies" => "scary" })

      expect(File.read(metadata_path)).to eq('{"bunnies":"scary"}')
    end
  end

  describe "#read_content" do
    it "reads the contents of the object file" do
      File.write(object_path, "Hello, world!")

      expect(subject.read_content.read).to eq("Hello, world!")
    end
  end

  describe "#read_metadata" do
    it "returns an empty hash if there's no metadata file" do
      expect(subject.read_metadata).to eq({})
    end

    it "returns the JSON from the metadata file converted to a hash" do
      File.write(metadata_path, '{"bunnies":"scary"}')

      expect(subject.read_metadata).to eq("bunnies" => "scary")
    end
  end

  describe "#object_path" do
    it "returns the path to the object" do
      expect(subject.object_path).to eq(object_path)
    end
  end

  describe "#metadata_path" do
    it "returns the path to the metadata" do
      expect(subject.metadata_path).to eq(metadata_path)
    end
  end

  describe "#directory_path" do
    it "returns the path to the directory containing the object" do
      expect(subject.directory_path).to eq(bucket_path)
    end
  end

end
