class TerritoriosController < ApplicationController

  def index
    @territorio = Territorio.pais.first
    render :action => :show_pais
  end
    
  def show
    @territorio = Territorio.find(params[:id])
    render :action => :"show_#{@territorio.descripcion_tipo}"
  end

end
