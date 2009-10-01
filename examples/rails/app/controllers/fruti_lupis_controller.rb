class FrutiLupisController < ApplicationController
  def index
    @fruti_lupis = FrutiLupi.all
  end

  def show
    @fruti_lupi = FrutiLupi.get(params[:id])
  end

  def new
    @fruti_lupi = FrutiLupi.new
  end

  def create
    @fruti_lupi = FrutiLupi.new(params[:fruti_lupi])
    if @fruti_lupi.save
      flash[:message] = "Fruti Lupi creado"
      redirect_to fruti_lupi_path(@fruti_lupi)
    else
      render :action => 'new'
    end
  end

  def edit
    @fruti_lupi = FrutiLupi.get(params[:id])
  end

  def update
    @fruti_lupi = FrutiLupi.get(params[:id])
    if @fruti_lupi.update_attributes(params[:fruti_lupi])
      flash[:message] = "Fruti Lupi actualizado"
      redirect_to fruti_lupi_path(@fruti_lupi)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @fruti_lupi = FrutiLupi.get(params[:id])
    @fruti_lupi.destroy
    redirect_to :action => 'index'
  end

end
