class Resultado < ActiveRecord::Base
  belongs_to :escrutinio
  belongs_to :partido


  # Los resultados tienen este formato
  #       <id_partido>226</id_partido>
  #       <nombre>PSOE</nombre>
  #       <electos>2</electos>
  #       <votos_numero>4398</votos_numero>
  #       <votos_porciento>46.97</votos_porciento>
  def self.create_from_api resultado_xml

    id_partido = resultado_xml.xpath("id_partido").first.content

    partido = Partido.find_or_create_by_id_api(id_partido, :nombre => resultado_xml.xpath("nombre").first.content)

    Resultado.create! :partido_id => partido.id, 
      :escanos => resultado_xml.xpath("electos").first.nil? ? nil : resultado_xml.xpath("electos").first.content.to_i,
      :total_votos => resultado_xml.xpath("votos_numero").first.content.to_i,
      :pct_votos => resultado_xml.xpath("votos_porciento").first.content.to_f      

  end

end
