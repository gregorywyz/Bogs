class TagsController < ApplicationController

  def index
    @tags = Tag.all
  end

  def new
  end

  def create
  end

  def destroy
  end

end