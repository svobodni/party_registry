class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def create
    @tag = ActsAsTaggableOn::Tag.new(tag_params)
    get_org_type
    respond_to do |format|
      if @tag.save
        format.html { redirect_to send("#{@org_type}_tasks_path",@tag.organization_id), notice: 'Štítek byl úspěšně vytvořen.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end

  end

  def new
    get_organization
    @tag = ActsAsTaggableOn::Tag.new
    @tag.organization_id = params[:organization_id]
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
        format.html { redirect_to tags_path, notice: 'Štítek byl úspěšně aktualizován.' }
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
    params.require(:acts_as_taggable_on_tag).permit(:id, :name, :organization_id)
  end

  def get_organization
    @organization = Organization.find(params[:organization_id])
    if @organization.type.to_s == "Region"
      @region = @organization
    elsif @organization.type.to_s == "Branch"
      @branch = @organization
    else
      @country = @organization
    end
  end

  def get_org_type
    @org_type = Organization.find(@tag.organization_id).type.underscore
  end
end