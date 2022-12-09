class CarsController < ApplicationController
  def new
    @car = Car.new
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
      @car_list = Car.where("number LIKE ?", "#{params[:leading_digit]}%")
    else
      @car_list = Car.all
    end
  end

  #多分使わない？
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
    end
  end

  def import; end

  def export; end

  private

  def car_params
    params.require(:car).permit(:division, :oil_type, :number,
                                :color, :model, :area, :hiragana,
                                :maker, :class_num, :remarks)
  end
end
