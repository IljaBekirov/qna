class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def type_id
    "#{self.class.name.downcase}_#{id}"
  end
end
