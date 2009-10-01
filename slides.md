!SLIDE

###### Fork me at git://github.com/ivanvc/presentacion-dm.git

DataMapper
==========

![Yellow - Blue - Red, Vassily Kandinsky](http://farm4.static.flickr.com/3127/3203922881_d728e93fce_b.jpg)

Yellow - Blue - Red, Vassily Kandinsky [via flickr ](http://www.flickr.com/photos/centralasian/3203922881/)


!SLIDE

# ¿Por qué DataMapper?

* id de los objetos

@@@ ruby
    @plato = Plato.first
    @plato.fruti_lupis.each do |fl|
      break unless @plato.object_id == fl.plato.object_id
    end
@@@

!SLIDE

# ¿Por qué DataMapper?

* Migraciones en los modelos
* Attributos y tablas independientes
* Lazy attributes

@@@ ruby
    class Persona
      include DataMapper::Resource
      belongs_to :fruti_lupi
      storage_names[:default] = 'el_vecindario' # el nombre de la tabla
      property :id,         Serial
      property :nombre,     String, :field => 'whats_your_name_ese'
      property :edad,       Integer, :lazy => true
    end
@@@

!SLIDE

# ¿Por qué DataMapper?
* Eager loading
  * Trivia: ¿Cuántos queries hago aquí?

@@@ ruby
    @platos = Plato.all
    @platos.each do |plato|
      plato.fruti_lupis.each do |fl|
        puts "Hola, soy: #{fl.dueno.nombre}"
      end
    end
@@@

<div class="right p-300">
  <img src="http://farm2.static.flickr.com/1104/1052687916_01b5dc1791.jpg" />
  <br />
  <small>Pleasures, V. Kandinsky <a href="http://www.flickr.com/photos/michaelrogers/1052687916/">via flickr</a></small>
</div>

!SLIDE

# ¿Por qué DataMapper?
* Eager loading
  * Trivia: ¿Cuántos queries hago aquí?

@@@ ruby
    @platos = Plato.all # 1
    @platos.each do |plato|
      plato.fruti_lupis.each do |fl| # 1*3 fruti lupis
        # pues el plato tiene tres fruti lupis
        puts "Hola, soy: #{fl.dueno.nombre}" # 1 
      end # 1 + 1 + 1 * 3  = 5?
    end
@@@

!SLIDE

# ¿Por qué DataMapper?
* Eager loading
  * Trivia: ¿Cuántos queries hago aquí?
    * AR = 5
    * DM = 3
    
@@@ sql
~ (0.000175) SELECT `id`, `nombre`, `created_at` FROM `platos` ORDER BY `id`
~ (0.000271) SELECT `id`, `color`, `tamano`, `created_at`, `plato_id` FROM `fruti_lupis` 
WHERE `plato_id` IN (1, 2) ORDER BY `id`
~ (0.000406) SELECT `id`, `nombre`, `fruti_lupi_id` FROM `personas` WHERE `fruti_lupi_id` 
IN (1, 2, 3, 4, 5) ORDER BY `id`
@@@

!SLIDE

# ¿Por qué DataMapper?
* Búsquedas más arubizadas (wtf)

@@@ ruby
        PlGroup.find(:all, 
        :conditions => ["lexicon_id=?", @lexicon.id],
        :order => "name DESC")
@@@

<div class="right p-380">
  <img src="http://farm4.static.flickr.com/3201/2971579946_1fa24211e7.jpg" />
  <br />
  <small>Improvisation 19 <a href="http://www.flickr.com/photos/jodene/2863474407/">via flickr</a></small>
</div>

!SLIDE

# ¿Por qué DataMapper?
* Búsquedas más arubizadas

@@@ ruby
        FrutiLupi.first(:color.eql => 'Azul')
        Persona.all(:age.gt => 30)
        Persona.last(:age.lte => 30)
        Plato.all(:nombre.not => 'hondo')
        Plato.all(:nombre.like => '%nd%')
        FrutiLupi.all(:color.eql => 'Morado', :id => [1, 3, 7])
        Persona.all(:nombre.not => ['reni','panchi'])
        Persona.all(:order => [:edad.desc])
@@@

!SLIDE

# ¿Por qué DataMapper?
* Búsquedas más arubizadas FTW

@@@ ruby
        PlGroup.all(:lexicon.eql => @lexicon.id, :order => [:name.desc])
@@@


!SLIDE 

# ¿Por qué DataMapper?

@@@ ruby
      PlGroup.find(:all, 
        :joins => "INNER JOIN playlists ON pl_groups.id=playlists.pl_group_id", 
        :conditions => ["playlists.lexicon_id=?", @lexicon.id],
        :order => "pl_groups.name DESC")
@@@

!SLIDE 

# ¿Por qué DataMapper?

@@@ ruby
      PlGroup.all( "playlists.lexicon_id.eql" => @lexicon.id,
                                      :order => [:name.desc])
@@@

<div class="right p-420">
  <img src="http://farm4.static.flickr.com/3267/2863474407_898f801720.jpg" />
  <br />
  <small>Picture with an archer,<br /> V. Kandinsky <a href="http://www.flickr.com/photos/jodene/2863474407/">via flickr</a></small>
</div>

!SLIDE

# Validaciones
## Explicitas
### dm-validations
### validates_(present, absent, is_accepted, is_confirmed, format, length, with_method, with_block, is_number, is_unique, within)

@@@ ruby
      validates_present :nombre
      validates_is_number [:edad, :telefono]
      validates_is_unique :correo, :scope => :sitio, :message => "Nel"
      validates_format :correo, :if => Proc.new { |p| p.new_record? }
@@@

!SLIDE

# Validaciones
## Implicitas
### En la migración

@@@ ruby
      property :nombre, String, :nullable => false
      property :tweet,  String, :length => (0...140)
      property :correo, String, :format => :email_address, :unique => true
@@@

!SLIDE

# Validaciones
## Custom

@@@ ruby
      validates_with_method :verificame_el_color_ese

      def verificame_el_color_ese
        if %w{amarillo verde morado}.includes? color
          true
        else
          [false, "Que ya te dije que nooo"]
        end
      end
@@@

!SLIDE

# Validaciones
## Mensajes de error

@@@ ruby
      validates_is_accepted :terminos, :message => 'Necesitamos tener tu alma'
      property :correo, String, :nullable => false, :unique => true, 
        :format => :email_address,
        :messages => {
          :presence => "El correo no puede estar en blanco",
          :is_unique => "Tu correo esta duplicado.",
          :format => "Estas seguro que es un correo?"
        }
        
      @futi_lupi.errors.add(:color, "Solo verde, amarillo, o morado :]")
@@@

!SLIDE

# Filtros

@@@ ruby
      after :save, :destruir_de_puro_desmadre
      before :valid?, :crear_permalink
      before_class_method :buscar, :preparar
      def self.preparar
        # Lo preparo
      end
      before :destroy do
        throw :halt #nunca me destruiran jo
      end
@@@

!SLIDE

# ¿Backups?
* Acepta múltiples repositorios en la configuración

@@@ yaml
          production:
            adapater: mysql
            database: prod
            username: ...
            repositories:
              repo1:
                adapter: ...
              repo2: ...
@@@


<div class="right p-420">
  <img src="http://farm4.static.flickr.com/3087/2869168125_791f6a8fc9.jpg" />
  <br />
  <small>Greyc out, V. Kandinsky <a href="http://www.flickr.com/photos/disenolibre-org/2869168125/">via flickr</a></small>
</div>

!SLIDE
# ¿Backups?
* Aja, ¿y luego?

@@@ ruby
        FrutiLupi.copy(:default, :repo1, :created_at.gte => 1.day.ago)
        FrutiLupi.copy(:repo2, :default, :updated_at.gte => 1.day.ago)
@@@

!SLIDE

![Near Paris I, V. Kandinsky](http://farm4.static.flickr.com/3010/2887480500_5baa9b81d6_b.jpg)

Near Paris I, V. Kandinsky  [via flickr ](http://www.flickr.com/photos/clairity/2887480500/)

!SLIDE
## Soy una persona de números, ¿que significa todo esto? Además yo amo ActiveRecord. Merb apesta.

- - -

## Bueno Sr. AR pro Rails from hell, ira, checate esto

!SLIDE

### Obtener 10,000 registros con AR ~ 1.3429s
### Obtener 10,000 registros con DM ~ 0.0002s

<div class="right p-300">
  <img src="http://farm4.static.flickr.com/3024/2971581954_480feda631.jpg" />
  <br />
  <small>Red Spot II, V. Kandinsky <a href="http://www.flickr.com/photos/clairity/2971581954/in/set-72157607246161127/">via flickr</a></small>
</div>

!SLIDE

### Obtener 1,000 registros con AR > 204,000q
### Obtener 1,000 registros con DM < 7,000q

touché 

!SLIDE

# Ok, 4 p*tas por favor
## Gems
  * data_mapper
  * do_mysql (o do_postrges o do_sqlite3)
  
## environemnt.rb

@@@ ruby
      config.frameworks -= [:active_record]
@@@

<div class="right p-380">
  <img src="http://farm4.static.flickr.com/3142/2971585302_e253a97be9.jpg" />
  <br />
  <small>Improvisation 26 <a href="http://www.flickr.com/photos/jodene/2863474407/">via flickr</a></small>
</div>

!SLIDE

# Ok, 4 p*tas por favor
## config/initializers/dm.rb

@@@ ruby
    require "dm-core"
    yaml = File.new(Rails.root + 'config' + 'database.yml')
    hash = YAML.load(yaml)
    DataMapper.setup(:default, hash[Rails.env])
@@@

## 

!SLIDE
# Fuentes
* [why_datamapper](http://datamapper.org/doku.php?id=why_datamapper)
* [Hooks](http://datamapper.org/doku.php?id=docs:hooks&s[]=hooks)
* [Validations](http://datamapper.org/doku.php?id=docs:validations&s[]=hooks)
* [DM in 20mins](http://www.slideshare.net/mattetti/datamapper-in-20-min-presentation)
* [Replacing ActiveRecord with DataMapper](http://www.slideshare.net/PeterDP/replacing-active-record-with-data-mapper-presentation)
* [Flickr](http://www.flickr.com/)