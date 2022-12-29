class BoardsController < ApplicationController
  before_action :invalid_ops, only: [:create]

  def index
    @board_list = Board.all.order(updated_at: :DESC)
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
    @post = Post.new
  end
  
  private
  
  def board_params
    params.require(:board).permit(:title, :name, :body)
  end
  
end
