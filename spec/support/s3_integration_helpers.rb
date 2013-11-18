require 'faraday'

module S3IntegrationHelpers
  def self.included(base)
    base.let(:s3_path) { "tmp" }

    base.let(:connection) do
      Faraday.new("http://s3.amazonaws.com") do |connection|
        connection.adapter :rack, FakeAWS::S3::RackApp.new(s3_path)
      end
    end

    base.before do
      FileUtils.rm_r(s3_path) rescue Errno::ENOENT
      FileUtils.mkdir(s3_path)
    end
  end
end
