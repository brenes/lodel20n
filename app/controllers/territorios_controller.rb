class TerritoriosController < ApplicationController

  def index
    @territorio = Territorio.pais.first
    @escrutinio = @territorio.ultimo_escrutinio
    @escrutinio_html = Decorators::Escrutinio::Html.new(@escrutinio)
    @escrutinio_seo = Decorators::Escrutinio::Seo.new(@escrutinio_html)
    render :action => :show_pais
  end
    
  def show
    @territorio = Territorio.find(params[:id])
    @escrutinio = @territorio.ultimo_escrutinio
    @escrutinio_html = Decorators::Escrutinio::Html.new(@escrutinio)
    @escrutinio_seo = Decorators::Escrutinio::Seo.new(@escrutinio_html)
    render :action => :"show_#{@territorio.descripcion_tipo}"
  end

end
