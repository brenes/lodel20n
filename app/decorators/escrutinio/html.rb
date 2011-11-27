module Decorators::Escrutinio
  class Html < Decorators::Base

    def titulo
      @decorated.final? ? "Escrutinio final" : "Escrutinio parcial <>(#{@decorated.pct_escrutado}%)</i>"
    end

    def fecha_actualizacion
      @decorated.final? ?
        "<p>Datos actualizados por última vez a las #{hora}</p>" :
        "<p>Datos definitivos</p>"  
    end

  end
end