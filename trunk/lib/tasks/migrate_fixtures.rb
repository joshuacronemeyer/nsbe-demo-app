module MigrateFixtures
  def gather_fixture_names(table_name, source_yaml)
    fixture_names = Hash.new
    if (table_name != "schema_info")
      source_yaml.keys.each { |key| fixture_names[source_yaml[key]["id"].to_s] = key}
    else
      fixture_names[nil] = source_yaml.keys.first
    end
    return fixture_names
  end
  
  def delete_fixtures(fixtures_path, deleted_tables)
    deleted_tables.each{|table_name| File.delete("#{fixtures_path}/#{table_name}.yml") if File.exists?("#{fixtures_path}/#{table_name}.yml")}  
  end
  
  def get_current_fixture_version
    schema_info_fixture = "#{RAILS_ROOT}/test/fixtures/schema_info.yml"
    yaml = YAML::load_file(schema_info_fixture)
    return yaml[(yaml.keys.first)]["version"].to_i
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
  
end