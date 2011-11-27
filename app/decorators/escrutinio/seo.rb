module Decorators::Escrutinio
    class Seo < Decorators::Base

      def header_seccion
        "<h2>#{@decorated.titulo}</h2>"
      end

    end
end