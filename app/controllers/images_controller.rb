require 'securerandom'
require 'mini_magick'

class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # GET /images
  # GET /images.json
  def index
    @images = Image.all
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(image_params)

    respond_to do |format|
      if @image.save
        GenerateThumbnailsJob.perform_later(@image.id)

        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    file_url = @image.url
    @image.destroy

    File.delete("public/uploads/#{file_url}")

    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload
    image_file = params[:file]
    guid_prefix = SecureRandom.uuid # Generate a unique number to rename the files to prevent duplication

    full_image_filename = guid_prefix + image_file.original_filename

    File.open(Rails.root.join('public', 'uploads', full_image_filename), 'wb') do |file|
      file.write(image_file.read)
      File.rename(file, 'public/uploads/' + full_image_filename)
    end

    render json: {message: 'You have successfully uploded your image.', url: full_image_filename}
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_image
    @image = Image.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def image_params
    params.require(:image).permit(:name, :url, :content_type)
  end
end
