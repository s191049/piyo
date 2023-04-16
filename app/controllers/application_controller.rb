class ApplicationController < ActionController::Base
  include ApplicationHelper
  def invalid_ops
    unless request.post?
      flash[:danger] = "不正な操作です"
      redirect_to root_path
    end
  end
end
