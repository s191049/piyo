class BoardsController < ApplicationController
  include ApplicationHelper
  before_action :invalid_ops, only: [:create]

  def index
    @board_list = Board.all.order(updated_at: :DESC).page(params[:page]).per(boards_per_page)
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.new(board_params)
    if @board.save
      @post = Post.new(name: @board.name)
    else
      flash.now[:danger] = "入力おかしいで"
      render 'new', status: :unprocessable_entity and return
    end
    redirect_to boards_show_path(@board)
  end

  def show
    @board = Board.find(params[:id])
    @post_list = @board.posts.page(params[:page]).per(posts_per_page)
    @post = Post.new
  end

  def destroy
    Board.find(params[:id]).destroy
    flash[:success] = "消したで"
    redirect_to boards_index_path
  end
  
  private
  
  def board_params
    params.require(:board).permit(:title, :name, :body)
  end
  
end
