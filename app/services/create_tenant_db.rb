class CreateTenantDb
    def self.call(institution)
      db_name = "tenant_#{institution.identifier}"
  
      ActiveRecord::Base.connection.execute("CREATE DATABASE #{db_name}")
  
      # 2. Update institution with DB details
      institution.update!(
        db_name: db_name,
        db_username: "root",
        db_password: "Soni$231",
        db_host: "db",
        db_port: 3306
      )
      binding.pry
      # 3. Run migrations on the new DB
      system("rails tenant:migrate[#{institution.identifier}]")

    end
  end
  