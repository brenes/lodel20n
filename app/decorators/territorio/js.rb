module Decorators::Territorio
  class Js < Decorators::Base

    def distribucion_partidos
      escrutinio = @decorated.ultimo_escrutinio

      "var data = #{escrutinio.resultados.map{|r| {:name => r.pct_votos > 0.5 ? r.partido.nombre : "", :pct => 1 + r.pct_votos*(100-escrutinio.resultados.count)/100}}.to_json};

        var w = 600,                        //width
        h = 400,                            //height
        r = 250,                            //radius
        color = d3.scale.category20c();     //builtin range of colors

        var vis = d3.select(\"#graphic\")
          .append(\"svg:svg\")              //create the SVG element inside the <body>
          .data([data])                   //associate our data with the document
            .attr(\"width\", w)           //set the width and height of our visualization (these will be attributes of the <svg> tag
            .attr(\"height\", h)
          .append(\"svg:g\")                //make a group to hold our pie chart
            .attr(\"transform\", \"translate(\" + r + \",\" + r + \")\")    //move the center of the pie chart from 0, 0 to radius, radius

        var arc = d3.svg.arc()              //this will create <path> elements for us using arc data
          .outerRadius(r);

    var pie = d3.layout.pie()           //this will create arc data for us given a list of values
        .value(function(d) { return d.pct; });    //we must tell it out to access the value of each element in our data array

    var arcs = vis.selectAll(\"g.slice\")     //this selects all <g> elements with class slice (there aren't any yet)
        .data(pie)                          //associate the generated pie data (an array of arcs, each having startAngle, endAngle and value properties) 
        .enter()                            //this will create <g> elements for every \"extra\" data element that should be associated with a selection. The result is creating a <g> for every object in the data array
            .append(\"svg:g\")                //create a group to hold each slice (we will have a <path> and a <text> element associated with each slice)
                .attr(\"class\", \"slice\");    //allow us to style things in the slices (like text)

        arcs.append(\"svg:path\")
                .attr(\"fill\", function(d, i) { return color(i); } ) //set the color for each slice to be chosen from the color function defined above
                .attr(\"d\", arc);                                    //this creates the actual SVG path using the associated data (pie) with the arc drawing function

        arcs.append(\"svg:text\")                                     //add a label to each slice
                .attr(\"transform\", function(d) {                    //set the label's origin to the center of the arc
                //we have to make sure to set these before calling arc.centroid
                d.innerRadius = 0;
                d.outerRadius = r;
                return \"translate(\" + arc.centroid(d) + \")\";        //this gives us a pair of coordinates like [50, 50]
            })
            .attr(\"text-anchor\", \"middle\")                          //center the text on it's origin
            .text(function(d, i) { return data[i].name; });        //get the label from our original data array
"
    end

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