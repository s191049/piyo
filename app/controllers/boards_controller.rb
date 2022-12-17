class BoardsController < ApplicationController
  def index
    @board_list = Board.all.order(updated_at: :DESC)
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.new(board_params)
    if @board.save
      
    else
      flash.now[:danger] = "入力おかしいで"
      render 'new', status: :unprocessable_entity and return
    end
    redirect_to boards_show_path(@board.id)
  end

  def show
    @board = Board.find(params[:id])
    @post = Post.new unless defined? @post
  end
  
  private
  
  def board_params
    params.require(:board).permit(:title, :name, :body)
  end
end
