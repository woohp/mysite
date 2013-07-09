class TodosController < ApplicationController
  before_filter :require_login
  respond_to :json

  def index
    respond_with current_user.todos
  end

  def show
    respond_with current_user.todos.find(params[:id])
  end

  def create
    todo = current_user.todos.create(todo_params) do |todo|
      todo.status = :pool
    end

    respond_with todo
  end

  def update
    todo = current_user.todos.find(params[:id])
    todo.update_attributes(todo_params)

    head :no_content
  end

  def destroy
    todo = current_user.todos.find(params[:id])
    todo.destroy
    
    head :no_content
  end

  private
  def todo_params
    params.require(:todo).permit(:title, :description)
  end
end
