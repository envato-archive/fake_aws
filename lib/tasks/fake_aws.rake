require 'fileutils'

namespace :fake_aws do
  desc 'Nuke all files inside the Fake AWS root directory'
  task :nuke => :environment do
    if Rails.application.config.fake_aws.present?
      Dir["#{Rails.application.config.fake_aws.fetch(:root_directory)}/**"].each do |f|
        puts "Removing: '#{f}'"
        FileUtils.rm_rf(f)
      end
    end
  end
end
