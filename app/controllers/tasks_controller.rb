class TasksController < ApplicationController

  before_action :set_task, only: [:show, :edit, :update, :destroy, :assign, :finish, :review]

  def review
    get_org_type
    respond_to do |format|
      if @task.update_attributes(reviewed_at: DateTime.now)
        format.html {redirect_to send("#{@org_type}_tasks_path",@task.organization_id), notice: 'Úkol byl úspěšně akceptován.'}
        format.json {render :show, status: :ok, location: @task}
      else
        format.html {render :edit}
        format.json {render json: @task.errors, status: :unprocessable_entity}
      end
    end
  end

  def assign
    get_org_type
    respond_to do |format|
      if @task.update_attributes(assigned_at: DateTime.now, person: current_user)
            format.html {redirect_to send("#{@org_type}_tasks_path",@task.organization_id), notice: 'Úkol byl úspěšně přidělen.'}
        format.json {render :show, status: :ok, location: @task}
      else
        format.html {render :edit}
        format.json {render json: @task.errors, status: :unprocessable_entity}
      end
    end
  end

  def finish
    get_org_type
    respond_to do |format|
      if @task.update_attributes(finished_at: DateTime.now)
        format.html {redirect_to send("#{@org_type}_tasks_path",@task.organization_id), notice: 'Úkol byl úspěšně dokončen.'}
        format.json {render :show, status: :ok, location: @task}
      else
        format.html {render :edit}
        format.json {render json: @task.errors, status: :unprocessable_entity}
      end
    end
  end

  # GET /tasks
  # GET /tasks.json
  def index
    load_organization
    @tasks_grid = initialize_grid(Task, include: [{tags: :taggings}, :author, :person], conditions: {organization_id: @organization.id})
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    load_organization
  end

  # GET /tasks/new
  def new
    @task = Task.new
    load_organization
  end

  # GET /tasks/1/edit
  def edit
    load_organization
  end

  # POST /tasks
  # POST /tasks.json
  def create
    puts task_params.as_json
    @task = Task.new(task_params)
    @task.author = current_user
    get_org_type
    respond_to do |format|
      if @task.save
        @task.tag_list.add(task_params[:tag_list])
        format.html {redirect_to send("#{@org_type}_tasks_path",@task.organization_id), notice: 'Úkol byl úspěšně vytvořen.'}
        format.json {render :show, status: :created, location: @task}
      else
        format.html {render :new}
        format.json {render json: @task.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    get_org_type
    respond_to do |format|
      if @task.update(task_params)
        @task.tag_list.add(task_params[:tag_list])
        format.html {redirect_to send("#{@org_type}_tasks_path",@task.organization_id), notice: 'Úkol byl úspěšně aktualizován.'}
        format.json {render :show, status: :ok, location: @task}
      else
        format.html {render :edit}
        format.json {render json: @task.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html {redirect_to tasks_url, notice: 'Task was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id] || params[:task_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:name, :description, :person_id, :organization_id, tag_list: [])
  end

  def load_organization
    if params[:region_id]
      @region = Region.find(params[:region_id])
      @body = @region.presidium
      @organization = @region
    elsif params[:branch_id]
      @branch = Branch.find(params[:branch_id])
      @organization = @branch
    else
      @organization = @country
    end
    @org_type = Organization.find(@organization.id).type.underscore
  end

  def get_org_type
    @org_type = Organization.find(@task.organization_id).type.underscore
  end
end
