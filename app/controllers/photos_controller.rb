class PhotosController < ApplicationController
  before_filter :authenticate, except: [:index]

  before_filter(only: :index) do |controller|
    authenticate unless controller.request.format.json?
  end

  # GET /photos
  # GET /photos.json
  def index
    if(params[:study])
      @photos = Photo.order("rank DESC").where("tag = ?", params[:study].gsub("\u00A0", " ").gsub("\u00C2", " ").strip)
    elsif(params[:frontpage])
      @photos = Photo.order("rank DESC").where("front_page = ?", true)
    else
      @photos = Photo.order("tag ASC, rank DESC").all
    end 

    @photos.each { |photo| photo.medium_url = photo.photo_file.url(:medium)  }  

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @photos.to_json({:only => [:name, :image_width], :methods => :medium_url}) }
    end
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.json
  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /photos/1/edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(params[:photo])

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: 'Photo was successfully created.' }
        format.json { render json: @photo, status: :created, location: @photo }
      else
        format.html { render action: "new" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.json
  def update
    puts y params['photo'].keys
    params['photo'].keys.each do |photo_id|
      photo = Photo.find(photo_id)
      photo.update_attributes(params['photo'][photo_id])
    end
    respond_to do |format|
      if true 
        format.html { redirect_to photos_path, notice: 'Photos were successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "index" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :ok }
    end
  end

  private

    def authenticate
      puts 'authenticate'
      deny_access unless is_admin?
    end
end
