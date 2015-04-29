class CreaturesController < ApplicationController

  def index
    @creatures = Creature.all
  end

  def new
    @creature = Creature.new
  end

  def create
    @creature = Creature.create(creature_params)
    redirect_to @creature
  end

  def show
    @creature = Creature.find(params[:id])
  end

  def edit
    @creature = Creature.find(params[:id])
  end

  def update
    @creature = Creature.update(params[:id], creature_params)
    redirect_to @creature
  end

  def destroy
    @creature = Creature.destroy(params[:id])
    # redirect_to @creature
    redirect_to creatures_path
  end

  private

  def creature_params
    params.require(:creature).permit(:name,:desc)
  end

end