require 'test/unit'
require 'rubygems'
require 'mocha'
require 'migrate_fixtures'
include MigrateFixtures

class MigrateFixturesTest < Test::Unit::TestCase

  def setup
    @yaml = {"two"=>{"name"=>"MyString", "id"=>"2"}, "one"=>{"name"=>"MyString", "id"=>"1"}}
  end

  def test_gather_fixture_names_so_we_can_remember_what_the_fixtures_were_called
    name_hash = gather_fixture_names("table_name", @yaml)
    assert_equal(@yaml.keys.first, name_hash["2"])
    assert_equal(@yaml.keys.last, name_hash["1"])
  end
  
  def test_gather_fixture_names_puts_schema_info_fixture_name_into_hash_with_nil_as_the_key
    name_hash = gather_fixture_names("schema_info", @yaml)
    assert_equal(1, name_hash.size)
    assert_equal(@yaml.keys.first, name_hash[nil])
  end
  
end