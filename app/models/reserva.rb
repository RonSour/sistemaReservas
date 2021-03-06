class Reserva < ApplicationRecord
  has_many :users
  has_many :habitacions
  #validates :cantidadPersonas, numericality: {only_integer: true, message: "Favor ingrese la cantidad de personas para hacer la reserva"}, presence: {message: "campo en blanco"}
  #validates :cantidadHabitaciones, numericality: {only_integer: true, message: "Favor ingrese la cantidad de habitacion para hacer la reserva"}, presence: {message: "campo en blanco"}
  #validates :estadoReserva, length: {in: 7..50, message: "Favor ingrese estado"}, presence: {message: "campo en blanco"}
  #validates :precioReserva, numericality: {only_integer: true, message: "Cantidad total invalida"}, presence: {message: "campo en blanco"}
  validate :validar_entrada, on: [:create,:new]
  validate :validar_salida, on: [:create, :new]
  validate :fechas_distintas
  validate :salida_mayor_que_entrada
  validate :numero_habitacion_no_blanco
  validates :habitacions_id, presence: {message: " No puede estar en blanco"}
  validates :habitacions_id, numericality: {only_integer: true, message: " Ingresa solo el numero (recuerda que es un numero entero)"}
  validate :validate_codigo_habitacion
  validate :estadia_maxima
  validate :fecha_anticipación, on: [:create,:new]
  #validate :singularidad_rango_fechas

  def fecha_anticipación
    if !fecha_ingreso.blank?
      anticipo = fecha_ingreso.day - Date.today.day
      if anticipo != 3
        errors.add(:fecha_ingreso,"Recuerda que debes realizar tu reserva con 3 días de anticipación")
      end
    end
  end

  def singularidad_rango_fechas
    errors.add(:fecha_ingreso, "No esta disponible") unless Reserva.where("? >= fecha_ingreso AND ? <= fecha_salida",
                                                                          fecha_ingreso, fecha_ingreso).count == 0
    errors.add(:fecha_salida, "No esta disponible") unless Reserva.where("? >= fecha_ingreso AND ? <= fecha_salida",
                                                                         fecha_salida, fecha_salida).count == 0
  end

  def validate_codigo_habitacion
    errors.add(:habitacions_id, "(Codigo) es invalido, puede que la habitacion no exista o ya este reservada") unless Habitacion.exists?(self.habitacions_id)
  end

  def numero_habitacion_no_blanco
    if habitacions_id.blank?
      errors.add(:habitacions_id," Recuerda ingresar el numero")
    end
  end

  def validar_entrada
    if !fecha_ingreso.blank?
      if fecha_ingreso < Date.today
        errors.add(:fecha_ingreso, "Esa fecha ya paso")
      end
    else
      errors.add(:fecha_ingreso,"Recuerda ingresar la fecha")
    end
  end

  def validar_salida
    if !fecha_salida.blank?
      if fecha_salida < Date.today
        errors.add(:fecha_salida,"Esa fecha ya paso")
      end
    else
      errors.add(:fecha_salida,"Recuerda ingresar la fecha")
    end
  end

  def fechas_distintas
    if !fecha_ingreso.blank? && !fecha_salida.blank?
      if fecha_ingreso == fecha_salida
        errors.add(:fecha_salida,"Recuerda que las fechas deben ser distintas")
      end
    end
  end

  def salida_mayor_que_entrada
      if !fecha_ingreso.blank? && !fecha_salida.blank?
        if fecha_ingreso > fecha_salida
          errors.add(:fecha_salida,"Recuerda que esta fecha debe ser despues de la de ingreso")
        end
      end
  end
  #valida que la estadia maxima sea de un mes
  def estadia_maxima
    if !fecha_ingreso.blank? && !fecha_salida.blank?
      estadia = fecha_salida.month - fecha_ingreso.month
      if estadia > 1
        errors.add(:fecha_salida, "¿segur@ que estaras tanto tiempo?, recuerda que nuestro maximo de estadia es de 1 mes")
      end
    end
  end
end
