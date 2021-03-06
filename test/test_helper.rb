require 'test/unit'
require 'rubygems'
require 'activesupport'
require 'active_record'
require 'active_record/fixtures'

# If you also want to test controllers etc. then require actionpack/actioncontroller here
# you will normally need to create at least one route or calls to url_for, redirect_to etc. will bomb

RAILS_ENV = 'test'

ActiveSupport::Dependencies.load_paths << File.expand_path(File.dirname(__FILE__) + "/../lib/")
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib/"))

class ActiveSupport::TestCase
  include ActiveRecord::TestFixtures
  self.fixture_path = File.dirname(__FILE__) + "/fixtures/"
  self.use_instantiated_fixtures  = false
  self.use_transactional_fixtures = true
end

def create_fixtures(*table_names, &block)
  Fixtures.create_fixtures(ActiveSupport::TestCase.fixture_path, table_names, {}, &block)
end
$LOAD_PATH.unshift(ActiveSupport::TestCase.fixture_path)


#Setup activerecord
config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))

RAILS_DEFAULT_LOGGER = ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")

#Have fun here if you want to run the plugin against multiple databases
ActiveRecord::Base.configurations = {'test' => config['sqlite']}
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])

#This creates the test database
load(File.dirname(__FILE__) + "/schema.rb")

#initialize the plugin
begin
  require File.dirname(__FILE__) + '/../init'
rescue MissingSourceFile # not all plugins have an init.rb
end
