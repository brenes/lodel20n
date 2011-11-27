namespace :elpais do

  desc "Tarea para descargar toda la estructura de territorios"
  task :descarga_territorios => :environment do

    VCR.use_cassette("elpais_estructura_#{Settings["year"]}", :record => :new_episodes) do
      
      Territorio.delete_all

      # Creamos el territorio del pais
      pais = Territorio.find_by_nombre("España")
      pais ||= Territorio.create! :nombre => "España", :tipo_api => Territorio.TIPOS_API[:pais]

      # Visitamos la página de El Pais y recorremos l a lista de comunidades
      Nokogiri::HTML(Net::HTTP.get(URI.parse(pais.pais_url))).xpath("//div[@id='otrasCCAAs']/ul/li/a/@href").each do |id_comunidad|


        str_id_comunidad =  id_comunidad.value.gsub("/", "")

        uri_comunidad = URI.parse("http://rsl00.epimg.net/elecciones/#{Settings["year"]}/generales/congreso/#{str_id_comunidad}/index.xml2")

        resultado_comunidad = Nokogiri::XML(Net::HTTP.get uri_comunidad)

 
        comunidad = Territorio.create_from_api str_id_comunidad, pais, resultado_comunidad

        puts "#{str_id_comunidad} " + comunidad.nombre

        contenido = Nokogiri::HTML(Net::HTTP.get(URI.parse(comunidad.pais_url)))

        contenido.xpath("//div[@id='otrasCircunscripciones']/ul/li/a/@href").each do |id_provincia|
          
          str_id_provincia =  id_provincia.value.gsub("/", "").gsub("\.html", "")

          uri_provincia = URI.parse("http://rsl00.epimg.net/elecciones/#{Settings["year"]}/generales/congreso/#{str_id_comunidad}/#{str_id_provincia}.xml2")

          resultado_provincia = Nokogiri::XML(Net::HTTP.get uri_provincia)        
        
          provincia = Territorio.create_from_api str_id_provincia, comunidad, resultado_provincia

          puts "---  #{str_id_provincia} " + provincia.nombre

          Nokogiri::HTML(Net::HTTP.get(URI.parse(provincia.pais_url))).xpath("//div[@id='listadoMunicipios']/ul/li/a/@href").each do |id_municipio|            

            str_id_municipio =  id_municipio.value.gsub(/^.*\//, "").gsub("\.html", "")
            
            uri_municipio = URI.parse("http://rsl00.epimg.net/elecciones/#{Settings["year"]}/generales/congreso/#{str_id_comunidad}/#{str_id_provincia}/#{str_id_municipio}.xml2")

            resultado_municipio = Nokogiri::XML(Net::HTTP.get uri_municipio)
            
            unless resultado_municipio.xpath("/escrutinio_sitio/nombre_sitio").first.nil?

              municipio = Territorio.create_from_api str_id_municipio, provincia, resultado_municipio

              puts "------  #{str_id_municipio} " + municipio.nombre
            end
          end

        end
      end
    end


  end

  desc "Tarea para descargar el escrutinio de los territorios en su estado actual"
  task :escrutinio => :environment do

    # Tarda tanto que podemos dejarlo en bucle sin problema
    while true
      Territorio.interesantes.each do |t|
        t.consultar_escrutinio
      end
    end

  end

end