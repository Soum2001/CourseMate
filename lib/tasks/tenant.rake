namespace :tenant do
    desc "Migrate a specific tenant"
    task :migrate, [:identifier] => :environment do |_t, args|
      identifier = args[:identifier]
      raise "Provide tenant identifier" unless identifier
  
      institution = Institution.find_by(identifier: identifier)
      raise "Tenant not found!" unless institution
  
      puts "== Switching to DB: #{institution.db_name} =="
  
      ActiveRecord::Base.establish_connection(
        adapter:  "mysql2",
        host:     institution.db_host,
        database: institution.db_name,
        username: institution.db_username,
        password: institution.db_password,
        port:     institution.db_port || 3306
      )
    
      puts "== Running migrations for tenant #{identifier} =="
      ActiveRecord::MigrationContext.new("db/migrate").migrate
    end
  end
  