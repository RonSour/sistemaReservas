class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  #campos numericos en la db, asignados con un "alias".
  enum user_role:  [:user , :admin]
  enum estado_habitacion: [:disponible , :ocupada]
  enum estado_user: [:activo, :inactivo]
end
