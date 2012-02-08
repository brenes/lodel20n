module Decorators::Territorio
  class Js < Decorators::Base

    def historico_partidos 
      @decorated.escrutinios.map do |escrutinio|
        "var data = #{escrutinio.resultados.map{|r| {:name => r.partido.nombre, :pct => r.pct_votos}}.to_json};

        var c = d3.scale.linear().domain([0,100]).range([\"rgb(50%, 0, 0)\", \"rgb(100%, 0, 0)\"]).interpolate(d3.interpolateRgb)
        var pct_acumulado = 100
        var vis = d3.select(\"#graphic\")
          .append(\"div\")
          .attr(\"width\", \"100%\")

        vis.append(\"span\")
            .text(\"#{escrutinio.hora}: #{escrutinio.pct_escrutado}%\")

        vis.selectAll(\"div\")
            .data(data)
            .enter().append(\"div\")
            .style(\"width\", function(d) { return d.pct+'%' })
            .style(\"clear\", function(d, i) { return (i == 0) ? \"left\" : \"none\" })
            .style(\"background-color\", function(d) { pct_acumulado -= d.pct; return  c(pct_acumulado + d.pct) })
            .text(function(d) { return d.name + '(' + d.pct+'%)'});"
      end.join("\n")
    end
    
  end
end