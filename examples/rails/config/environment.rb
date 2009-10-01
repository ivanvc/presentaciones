RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem "rails_datamapper"
  config.gem "do_sqlite3"
  config.gem "haml"
  config.frameworks -= [:active_record]
  config.time_zone = 'UTC'
end