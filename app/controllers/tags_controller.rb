class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def create
    @tag = ActsAsTaggableOn::Tag.new(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to tags_path, notice: 'Tag was successfully created.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end

  end

  def new
    @tag = ActsAsTaggableOn::Tag.new
  end

  def index
    @tags_grid = initialize_grid(ActsAsTaggableOn::Tag)
  end

  def edit
  end

  def update
    @tag = ActsAsTaggableOn::Tag.find(params[:id])

    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to tags_path, notice: 'Tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end

  end

  private

  def set_tag
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
  end

  def tag_params
    params.require(:acts_as_taggable_on_tag).permit(:id, :name)
  end

end