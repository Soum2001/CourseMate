class MainRecord < ActiveRecord::Base
    self.abstract_class = true
  
    connects_to database: { reading: :primary, writing: :primary }
  end
  