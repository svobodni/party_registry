class TasksController < ApplicationController

  before_action :set_task, only: [:show, :edit, :update, :destroy, :assign, :finish, :review]

  def review
    respond_to do |format|
      if @task.update_attributes(reviewed_at: DateTime.now)
        format.html { redirect_to tasks_path, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def assign
    respond_to do |format|
      if @task.update_attributes(assigned_at: DateTime.now, user: current_user)
        format.html { redirect_to tasks_path, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def finish
    respond_to do |format|
      if @task.update_attributes(finished_at: DateTime.now)
        format.html { redirect_to tasks_path, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks_grid = initialize_grid(Task, include: [{tags: :taggings}, :author, :person])
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    puts task_params.as_json
    @task = Task.new(task_params)

    @task.author = current_user

    respond_to do |format|
      if @task.save
        @task.tag_list.add(task_params[:tag_list])
        format.html { redirect_to root_path, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        @task.tag_list.add(task_params[:tag_list])
        format.html { redirect_to tasks_path, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id] || params[:task_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :description, :person_id, tag_list: [])
    end
end
