####
# PostgreSQL schema
#
# Use PostgreSQL schemas for storing different Rails environments.

require 'active_record/connection_adapters/postgresql_adapter'

module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter
      # Patch table_exists to lookup for the table in the configured working_schema, not in all schemas
      def table_exists_with_config_default_schema?(name)
        schema, table = name.to_s.split('.', 2)

        unless table # A table was provided without a schema
          table  = schema
          schema = @config[:working_schema] ? @config[:working_schema] : nil
        end
        
        table_exists_without_config_default_schema?("#{schema}.#{table}")
      end
      alias_method_chain :table_exists?, :config_default_schema
    end
  end
end

# Load rake task
module PostgresqlSchema
  # This is the actual version of the PostgresqlSchema gem
  VERSION = ::File.read(::File.join(::File.dirname(__FILE__), "..", "VERSION")).strip  
    
  def self.load options = {} #:nodoc:
    require ::File.expand_path('../postgresql_schema/rake_tasks', __FILE__)
  end
  
  # This is the path to the PostgresqlSchema gem's root directory
  def base_directory
    ::File.expand_path(::File.join(::File.dirname(__FILE__), '..'))
  end
  
  # This is the path to the PostgresqlSchema gem's lib directory
  def lib_directory
    ::File.expand_path(::File.join(::File.dirname(__FILE__)))
  end
  
  module_function :base_directory, :lib_directory
end