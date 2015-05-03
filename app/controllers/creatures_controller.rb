class CreaturesController < ApplicationController


  def index
    @creatures = Creature.all
  end

  def new
    @creature = Creature.new
    @tags = Tag.all
  end

  def create
    @creature = Creature.create(creature_params)

    tags = params[:creature][:tag_ids]
    tags.each do |tag_id|
      @creature.tags << Tag.find(tag_id) unless tag_id.blank?
    end
    redirect_to @creature
  end

  def show
    @creature = Creature.find(params[:id])

    # Flicker API

    photo_list = flickr.photos.search :text => "snake", :per_page => 10, :sort => "relevance"

    id = photo_list[0].id
    secret = photo_list[0].secret
    info = flickr.photos.getInfo :photo_id => id

    @img_url = FlickRaw.url_c(info)

    @url_list = []
    photo_list.each do |item|
      item_info = flickr.photos.getInfo :photo_id => item.id
      @url_list << FlickRaw.url_c(item_info)
    end
  end

  def edit
    @creature = Creature.find(params[:id])
    @tags = Tag.all
  end

  def update
    @creature = Creature.update(params[:id], creature_params)
    # @creature << Tag.find(creature_params)

    @creature.tags.clear
    tags = params[:creature][:tag_ids]
    tags.each do |tag_id|
      @creature.tags << Tag.find(tag_id) unless tag_id.blank?
    end

    redirect_to @creature
  end

  def destroy
    @creature = Creature.destroy(params[:id])
    redirect_to @creature
  end

  private

  def creature_params
    params.require(:creature).permit(:name,:desc)
  end

end