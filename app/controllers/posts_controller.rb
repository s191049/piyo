class PostsController < ApplicationController
  def create
    @post = Post.new(post_params)
    @board = Board.find(@post.board_id)
    if @post.save
      @board.touch
      @post = Post.new(name:@post.name)
    else
      flash.now[:danger] = "入力おかしいで"
      render 'boards/show', collection: @board and return
    end
    render 'boards/show', collection: @board
  end
  
  private
  
  def post_params
    params.require(:post).permit(:board_id, :name, :body)
  end
end
