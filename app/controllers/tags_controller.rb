class TagsController < ApplicationController

  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find(params[:id])
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.create(tag_params)
    redirect_to tags_path
  end

  def destroy
    @tag = Tag.find(params[:id])

    unless @tag.creatures
      Tag.destroy(params[:id])
    else
      flash[:info] = "Cannot delete this tag. This tag has #{@tag.creatures.length} " + "creature".pluralize(@tag.creatures.length)
    end

    redirect_to tags_path
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

end