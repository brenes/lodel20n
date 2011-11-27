class Escrutinio < ActiveRecord::Base
  belongs_to :territorio
  has_many :resultados

  scope :final, where(:pct_escrutado => 100)

    # Los escrutinios tienen este formato
    # <escrutinio_sitio>
    #   <porciento_escrutado>100</porciento_escrutado>
    #   <nombre_sitio>Barbastro</nombre_sitio>
    #   <ts>0</ts>
    #   <tipo_sitio>5</tipo_sitio>
    #   <votos>
    #     <contabilizados><cantidad>9433</cantidad><porcentaje>77.5</porcentaje></contabilizados>
    #     <abstenciones><cantidad>2738</cantidad><porcentaje>22.5</porcentaje></abstenciones>
    #     <nulos><cantidad>70</cantidad><porcentaje>0.74</porcentaje></nulos>
    #     <blancos><cantidad>113</cantidad><porcentaje>1.21</porcentaje></blancos>
    #   </votos>
    #   <resultados>
    #     <numero_partidos>20</numero_partidos>
    #     <partido>
    #       <id_partido>226</id_partido>
    #       <nombre>PSOE</nombre>
    #       <electos>2</electos>
    #       <votos_numero>4398</votos_numero>
    #       <votos_porciento>46.97</votos_porciento>
    #     </partido>
    #   </resultados>
    # </escrutinio_sitio>
  def self.create_from_api territorio, escrutinio_xml
    
    hora = escrutinio_xml.xpath("/escrutinio_sitio/ts").first.content
    hora = (hora == 0) ? nil : hora

    escrutinio = Escrutinio.find_by_territorio_id_and_hora(territorio.id, hora)
    # si tenemos escrutinio de esta hora no lo repetimos
    return escrutinio unless escrutinio.nil?

    escrutinio = Escrutinio.create! :territorio_id => territorio.id, :hora => hora, 
      :pct_escrutado => escrutinio_xml.xpath("/escrutinio_sitio/porciento_escrutado").first.content,
      :total_contabilizados => escrutinio_xml.xpath("/escrutinio_sitio/votos/contabilizados/cantidad").first.content,
      :pct_contabilizados => escrutinio_xml.xpath("/escrutinio_sitio/votos/contabilizados/porcentaje").first.content,
      :total_abstenciones => escrutinio_xml.xpath("/escrutinio_sitio/votos/abstenciones/cantidad").first.content,
      :pct_abstenciones => escrutinio_xml.xpath("/escrutinio_sitio/votos/abstenciones/porcentaje").first.content,
      :total_nulos => escrutinio_xml.xpath("/escrutinio_sitio/votos/nulos/cantidad").first.content,
      :pct_nulos => escrutinio_xml.xpath("/escrutinio_sitio/votos/nulos/porcentaje").first.content,
      :total_blanco => escrutinio_xml.xpath("/escrutinio_sitio/votos/blancos/cantidad").first.content,
      :pct_blanco => escrutinio_xml.xpath("/escrutinio_sitio/votos/blancos/porcentaje").first.content

    escrutinio_xml.xpath("/escrutinio_sitio/resultados/partido").each do |resultado_xml|
      escrutinio.resultados << Resultado.create_from_api(resultado_xml)
    end
    escrutinio
  end

  def final?
    pct_escrutado == 100
  end
end
