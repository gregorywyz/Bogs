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
    @url_list = []

    # Flicker API

    photo_list = flickr.photos.search :text => @creature.name, :content_type => 1, :per_page => 10, :privacy_filter => 1, :sort => "relevance"

    # id = photo_list[0].id
    # secret = photo_list[0].secret
    # info = flickr.photos.getInfo :photo_id => id

    # # render :json => info
    # @img_url = FlickRaw.url_c(info)

    photo_list.each do |item|

      p "new item found ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

      item_info = flickr.photos.getInfo :photo_id => item.id

      # # gives url to page with pic
      # puts item_info.urls[0]._content

      @url_list << FlickRaw.url(item_info)

      # @url_list << {:pic => FlickRaw.url(item_info), :url => item_info.urls[0]._content}
    end

    # @url_list = photo_list.map do |item|
    #   item_info = flickr.photos.getInfo :photo_id => item.id
    #   {:pic => FlickRaw.url(item_info), :url => item_info.urls[0]._content}
    # end
    # render :json => @url_list
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