namespace :db do
  # Use own create_database, which will create a schema instead of a database if working_schema is configured in database.yml
  def create_database(config)
    @encoding = config['encoding'] || ENV['CHARSET'] || 'utf8'
    begin
      if schema_name=config['working_schema']
        ActiveRecord::Base.establish_connection(config.merge('schema_search_path' => 'public'))
        ActiveRecord::Base.connection.execute "CREATE SCHEMA \"#{schema_name}\"" #" AUTHORIZATION \"#{config['username']}\""
        ActiveRecord::Base.establish_connection(config)
        ActiveRecord::Base.connection.execute('CREATE TABLE "schema_migrations" (
        	"version" varchar(255) NOT NULL
        )
        WITH (OIDS=FALSE);')
        ActiveRecord::Base.connection.execute("ALTER TABLE \"schema_migrations\" OWNER TO \"#{config['username']}\";")
      else
        ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
        ActiveRecord::Base.connection.create_database(config['database'], config.merge('encoding' => @encoding))
        ActiveRecord::Base.establish_connection(config)
      end  
    rescue Exception => e
      $stderr.puts e, *(e.backtrace)
      $stderr.puts "Couldn't create database for #{config.inspect}"
    end
  end
  
  def drop_database(config)
    # Use own drop_database, which will drop a schema instead of a database if working_schema is configured in database.yml
    begin
      if schema_name=config['working_schema']
        ActiveRecord::Base.establish_connection(config.merge('schema_search_path' => 'public'))
        ActiveRecord::Base.connection.execute "DROP SCHEMA IF EXISTS \"#{schema_name}\" CASCADE"
      else
        ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
        ActiveRecord::Base.connection.drop_database config['database']
      end
    rescue Exception => e
      $stderr.puts e, *(e.backtrace)
      $stderr.puts "Couldn't drop database for #{config.inspect}"
    end
  end
end

# just put some info about postgresql_schema
namespace :postgresql_schema do
  desc  'Some Information about postgresql_schema'
  task :about do
    puts "Using PostgreSQL schemas for storing different Rails environments."
    puts ""
    puts "See https://github.com/starpeak/postgresql_schema for further information."
  end
end