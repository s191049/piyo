class CarsController < ApplicationController
  def new
    if params[:car_number].nil?
      @car = Car.new
    else
      @car = Car.new(number:params[:car_number], division:params[:car_division])
    end
  end

  def confirm
    @car = Car.new(car_params)
    if @car.invalid?
      @car.save
      flash.now[:danger] = '入力おかしいで'
      render 'new', status: :unprocessable_entity and return
    elsif @car.find_match.count > 0
      # それっぽいのがあった場合
      @find_list = @car.find_match
    else
      @find_list = @car.find_match
    end
    # confirmにredirect
  end

  def create
    @car = Car.new(car_params)
    if @car.save
      flash[:success] = "登録したで"
      redirect_to cars_show_path(@car.id)
    else
      flash.now[:danger] = "あかんかったわ"
      render 'new', status: :unprocessable_entity and return
    end
  end
  
  def index
    #debugger
    if params[:leading_digit].to_i.to_s == params[:leading_digit] && params[:leading_digit].to_i.between?(1,9)
      @car_list = Car.order(number: :ASC).where("number LIKE ?", "#{params[:leading_digit]}%")
    else
      redirect_to "#{cars_index_path}/1"
    end
  end

  def show
    @car = Car.find(params[:id])
  end

  def edit
    @car = Car.find(params[:id])
  end

  def update
    @car = Car.find(params[:id])
    @car.update(car_params)
    flash[:success] = "編集したで"
    redirect_to "#{cars_show_path}"
  end

  def destroy
    Car.find(params[:id]).destroy
    flash[:success] = "消したで"
    redirect_to cars_index_path
  end

  def search
    #debugger
    #if (defined? params.require(:car)) == nil
    #if params.require(:car) == nil
    if params[:car].nil?
      @car = Car.new
    else
      @car = Car.new(car_params)
      @car_list = @car.find_match
      #redirect_to cars_search_path(@car_list, anchor: 'search-result') and return
      render 'search' and return
    end
  end

  def import
    unless params[:csv].nil?
      if params[:csv].content_type != "text/csv"
        flash.now[:danger] = "ファイルが不正です"
        render 'import', status: :unprocessable_entity and return
      else
        Car.import(params[:csv])
      end
    end
  end

  def export; end

  private

  def car_params
    params.require(:car).permit(:division, :oil_type, :number,
                                :color, :model, :area, :hiragana,
                                :maker, :class_num, :remarks)
  end
end
