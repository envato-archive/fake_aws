require 'spec_helper'

describe FakeAWS::S3::BucketOnDisk do
  let(:root_directory)     { "tmp" }
  let(:bucket)             { "mah-bucket" }

  subject { described_class.new(root_directory, bucket) }

  let(:bucket_path)        { "tmp/mah-bucket" }

  before do
    FileUtils.rm_r(root_directory) rescue Errno::ENOENT
  end

  describe "#exists?" do
    it "returns true if the bucket directory exists" do
      FileUtils.mkdir_p(bucket_path)
      expect(subject.exists?).to be_truthy
    end

    it "returns false if the bucket directory doesn't exist" do
      expect(subject.exists?).to be_falsy
    end
  end

  describe "#create" do
    it "creates the bucket directory" do
      subject.create
      expect(Dir.exists?(bucket_path)).to be_truthy
    end
  end

  describe "#path" do
    it "returns the path to the bucket" do
      expect(subject.path).to eq(bucket_path)
    end
  end

end
