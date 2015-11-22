namespace :db do
  namespace :migrate do
    task :squash => :environment do
      db_migrate_path = Rails.root.join('db/migrate')

      ActiveRecord::Base.establish_connection(Rails.env.to_sym || :production)

      ActiveRecord::SchemaDumper.class_eval do
        def dump(stream)
          tables(stream)
        end
      end

      schema_dump = ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, StringIO.new).string

      squashed_migration = db_migrate_path.join("0_squashed_migration.rb")

      squashed_migration.write(<<RUBY)
class SquashedMigration < ActiveRecord::Migration
  def change
#{schema_dump}
  end
end
RUBY

      old_migrations_dir = Rails.root.join('doc/migrations')
      old_migrations_dir.mkpath

      migrated_versions = ActiveRecord::Base.connection.select_values("SELECT version FROM #{ActiveRecord::Migrator.schema_migrations_table_name}")
      migrated_versions.map! {|v| v.to_i }

      (Pathname.glob("#{db_migrate_path}/*.rb") - [squashed_migration]).each do |file|
        file_version = file.to_s[/\d{3,}/].to_i
        if migrated_versions.include? file_version
          FileUtils.mv file, old_migrations_dir
        end
      end
    end
  end
end