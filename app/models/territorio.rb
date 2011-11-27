class Territorio < ActiveRecord::Base
  has_many :escrutinios
  belongs_to :padre, :class_name => "Territorio", :foreign_key => "territorio_padre_id"
  has_many :hijos, :class_name => "Territorio", :foreign_key => "territorio_padre_id"

  @@TIPOS_API = {:pais => 1, :comunidad => 2, :provincia => 3, :municipio => 5}
  cattr_reader :TIPOS_API

  @@TIPOS_API.each do |name, id|
    scope name.to_sym, where(:tipo_api => id)
  end

  scope :interesantes,  where("tipo_api = #{@@TIPOS_API[:pais]} OR tipo_api = #{@@TIPOS_API[:comunidad]} OR tipo_api = #{@@TIPOS_API[:provincia]}")
  def self.create_from_api id, padre, xml
    num_a_elegir =  xml.xpath("/escrutinio_sitio/num_a_elegir").first
    tipo = xml.xpath("/escrutinio_sitio/tipo_sitio").first.content
    territorio = Territorio.find_by_id_api_and_tipo_api_and_territorio_padre_id(id, tipo, padre.id) || Territorio.create!(:nombre => xml.xpath("/escrutinio_sitio/nombre_sitio").first.content, 
      :tipo_api => tipo, 
      :id_api => id, 
      :escanos => (num_a_elegir.nil? ? nil  : num_a_elegir.content), 
      :padre => padre)
  end

  def descripcion_tipo
    @@TIPOS_API.invert[tipo_api]
  end

  def api_url 
    send :"api_url_#{descripcion_tipo}"
  end

  def pais_url 
    send :"pais_url_#{descripcion_tipo}"
  end

  def consultar_escrutinio  
    escrutinio_xml = Nokogiri::XML(Net::HTTP.get(URI.parse(api_url)))
    escrutinios << Escrutinio.create_from_api(self, escrutinio_xml)
  end

  def ultimo_escrutinio
    escrutinios.final.first || escrutinios.first(:order => "hora DESC")
  end

  protected

  def api_url_pais
    "http://rsl00.epimg.net/elecciones/#{Settings["year"]}/generales/congreso/index.xml2"
  end

  def pais_url_pais
    "http://resultados.elpais.com/elecciones/#{Settings["year"]}/generales/congreso/"
  end

  def api_url_comunidad
    "http://rsl00.epimg.net/elecciones/#{Settings["year"]}/generales/congreso/#{id_api}/index.xml2"
  end

  def pais_url_comunidad
    "http://resultados.elpais.com/elecciones/#{Settings["year"]}/generales/congreso/#{id_api}/"
  end

  def api_url_provincia
    "http://rsl00.epimg.net/elecciones/#{Settings["year"]}/generales/congreso/#{padre.id_api}/#{id_api}.xml2"
  end

  def pais_url_provincia
    "http://resultados.elpais.com/elecciones/#{Settings["year"]}/generales/congreso/#{padre.id_api}/#{id_api}.html"
  end

  def api_url_municipio
    "http://rsl00.epimg.net/elecciones/#{Settings["year"]}/generales/congreso/#{padre.padre.id_api}/#{padre.id_api}/#{id_api}.xml2"
  end

  def pais_url_municipio
    "http://resultados.elpais.com/elecciones/#{Settings["year"]}/generales/congreso/#{padre.padre.id_api}/#{padre.id_api}/#{id_api}.html"
  end
end
