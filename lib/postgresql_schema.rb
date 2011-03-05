require 'active_record/connection_adapters/postgresql_adapter'

module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter
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