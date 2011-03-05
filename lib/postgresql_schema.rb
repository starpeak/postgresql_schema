####
# PostgreSQL schema
#
# Use PostgreSQL schemas for storing different Rails environments.

Dir["#{::File.dirname(__FILE__)}/tasks/**/*.rake"].each { |ext| load ext } if defined?(Rake)

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
