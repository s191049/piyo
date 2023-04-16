class PostsController < ApplicationController
  include ApplicationHelper
  before_action :invalid_ops, only: [:create]

  def create
    @post = Post.new(post_params)
    @board = Board.find(@post.board_id)
    if @post.save
      @board.touch
      @post = Post.new(name:@post.name)
      @post_list = @board.posts.page(params[:page]).per(posts_per_page)
    else
      flash.now[:danger] = "入力おかしいで"
      @post_list = @board.posts.page(params[:page]).per(posts_per_page)
      render 'boards/show', collection: @board and return
    end
    # render 'boards/show', collection: @board
    redirect_to boards_show_path @board
  end
  
  private
  
  def post_params
    params.require(:post).permit(:board_id, :name, :body, attached_files: [])
  end
end
