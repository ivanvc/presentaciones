require 'rubygems'
require 'dm-core'
DataMapper::Logger.new(STDOUT, :debug)

# sqlite 3 en memoria
#DataMapper.setup(:default, 'sqlite3::memory:')
# sqlite3 en un archivo
#DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/test.db")
# mysql
DataMapper.setup(:default, 'mysql://localhost/datamapper_example')
# postgresql
#DataMapper.setup(:default, 'postgres://localhost/dm_core_test')
class Persona
  include DataMapper::Resource
  belongs_to :fruti_lupi
  storage_names[:default] = 'el_vecindario' # el nombre de la tabla
  property :id,         Serial
  property :nombre,     String, :field => 'whats_your_name_ese'
  property :edad,       Integer, :lazy => true
end
class FrutiLupi
  include DataMapper::Resource
  belongs_to :plato
  has 1, :dueno, :class_name => 'Persona'
  property :id,         Serial
  property :color,      String
  property :tamano,     String # Por eso de los fruti lupis gigantes
  property :created_at, DateTime
end
class Plato
  include DataMapper::Resource
  has 0..12, :fruti_lupis
  property :id,         Serial
  property :nombre,     String
  property :created_at, DateTime  
end
#FrutiLupi.auto_migrate!
#Plato.auto_migrate!
# o todas las clases que incluyen DataMapper::Resource
DataMapper.auto_migrate!

puts "Generando Plato"
@plato = Plato.create(:nombre => "hondo")
puts "@plato.object_id = #{@plato.object_id}"
Plato.create(:nombre => "plano")

puts "Generando cinco Fruti Lupis"
colores = %w{Verde Amarillo Morado Rojo}
tamanos = %w{Normal Gigante}
5.times do 
  FrutiLupi.create(
    :color  => colores[rand(3)], 
    :tamano => tamanos[rand(2)],
    :plato_id => @plato.id)
end

puts "Recorriendo el plato y comparando object id contra el object id del padre"
@plato.fruti_lupis.each do |fl|
  puts "El object id del padre es igual al de la variable de instancia?"
  puts @plato.object_id == fl.plato.object_id
end

personas = %w{Panchi Reni Tocayo Rene}
puts "Ahora a agregar personas"
FrutiLupi.all.each do |fl|
  Persona.create(
  :nombre         => personas[rand(3)], 
  :edad           => rand(5)+20,
  :fruti_lupi_id  => fl.id)
end

puts "Me pregunto cuántos queries haré para recorrer a Plato, Fruti Lupi y persona.."
@platos = Plato.all
@platos.each do |plato|
  plato.fruti_lupis.each do |fl|
    puts "Hola, soy: #{fl.dueno.nombre}"
  end
end

puts "Pero el atributo edad es lazy, qué pasará? qué misterio habrá?"
@persona = Persona.first
puts "Nombre: #{@persona.nombre}"
puts "Edad: #{@persona.edad}"