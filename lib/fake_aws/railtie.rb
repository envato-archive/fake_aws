module FakeAws
  class Railtie < Rails::Railtie
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'../tasks/*.rake')].each do |f|
        load f
      end
    end
  end
end