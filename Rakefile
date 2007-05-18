# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'yaml'
require 'tasks/rails'

#Thoughts on fixture migrations
#
#We have introduced the concept of a version to the fixtures.  If we want to make this a part of rails
#and not just a hack for migrating fixtures (currently thats what it is) then we need to change the rake
#tasks that load tests to use migration instead of just copying the schema from the development db.  (We can't guarantee
#what version the development db is at.)  We would also have to think about the generators that generate migrations
#is there some work to be done on those to accomidate the version.  For example when they add a new model...
#
#If we go this route people will have to be mindful of fixtures or they won't be able to run tests.
#
#
#
#Things we should consider:
#adding this code to the Fixture class.  but is adding a dependency on ActiveRecord::Migrator a problem?
#
#we don't handle csv fixtures well.  they will get upgraded but output will be yaml
#
#the initial case when there is not a schema_info.yml file.  we should default to latest version.
#
namespace :db do
namespace :fixtures do
desc "Run migrations on your test fixtures."
task :migrate do
  fixtures_path = "#{RAILS_ROOT}/test/fixtures"
  #dump test db in case it isn't empty
  Rake::Task["db:test:purge"].invoke
  ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
  #create db at the same version of our fixtures
  ActiveRecord::Migrator.migrate("db/migrate/", get_current_fixture_version())
  initial_tables = ActiveRecord::Base.connection.tables
  RAILS_ENV = "test"
  #load fixture
  Rake::Task["db:fixtures:load"].invoke
  ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
  #migrate fixtures
  Rake::Task["db:migrate"].invoke
  #dump fixtures back out.
  ActiveRecord::Base.connection.tables.each do |table_name|
    yaml_file_name = "#{fixtures_path}/#{table_name}.yml"
    if (File.exists?(yaml_file_name))
      yaml = YAML::load_file(yaml_file_name)
      fixture_names = gather_fixture_names(table_name, yaml)
      top_of_file_comment = grab_comment_from_top_of_file(yaml_file_name)
      write_fixture_to_file(table_name, yaml_file_name, fixture_names, top_of_file_comment)
    end
  end
  resulting_tables = ActiveRecord::Base.connection.tables
  deleted_tables = initial_tables - resulting_tables
  puts deleted_tables
  delete_fixtures(fixtures_path, deleted_tables)
end
end
end

def delete_fixtures(fixtures_path, deleted_tables)
  deleted_tables.each{|table_name| File.delete("#{fixtures_path}/#{table_name}.yml") if File.exists?("#{fixtures_path}/#{table_name}.yml")}  
end

def get_current_fixture_version
  schema_info_fixture = "#{RAILS_ROOT}/test/fixtures/schema_info.yml"
  yaml = YAML::load_file(schema_info_fixture)
  return yaml[(yaml.keys.first)]["version"].to_i
end

def gather_fixture_names(table_name, source_yaml)
  fixture_names = Hash.new
  if (table_name != "schema_info")
    source_yaml.keys.each { |key| fixture_names[source_yaml[key]["id"].to_s] = key}
  else
    fixture_names[nil] = source_yaml.keys.first
  end
  return fixture_names
end

def grab_comment_from_top_of_file yaml_file_name
  File.open(yaml_file_name, 'r') do |file|
    comments = ""
    file.each_line do |line| 
      if (/^#/ =~ line) 
        comments << line
      end
    end
    comments
  end
end

def write_fixture_to_file(source_table_name, destination_file_name, fixture_names, top_of_file_comment)
  sql  = 'SELECT * FROM %s'
  File.open(destination_file_name, File::RDWR|File::TRUNC|File::CREAT) do |file|
    file.write(top_of_file_comment)
    table = ActiveRecord::Base.connection.select_all(sql %source_table_name).inject({}) do |hash, record|
      hash[fixture_names[record["id"]]] = record
      hash
    end
    file.write(table.to_yaml)
  end
end

