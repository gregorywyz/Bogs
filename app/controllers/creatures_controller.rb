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
    # render :json => photo_list

    photo_list.each do |item|
      item_info = flickr.photos.getInfo :photo_id => item.id
      @url_list << FlickRaw.url(item_info)

      # # trying to allow for image url and page url to both be passed to render (attmpt 1)
      # @url_list << {:pic => FlickRaw.url(item_info), :url => item_info.urls[0]._content}
    end

      # # trying to allow for image url and page url to both be passed to render (attmpt 2)
      # @url_list = photo_list.map do |item|
      #   item_info = flickr.photos.getInfo :photo_id => item.id
      #   {:pic => FlickRaw.url(item_info), :url => item_info.urls[0]._content}
      # end
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