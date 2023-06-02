class CarsController < ApplicationController
  before_action :invalid_ops, only: [:confirm, :create]
  def new
    if params[:car_number].nil?
      @car = Car.new
    else
      @car = Car.new(number:params[:car_number], division:params[:car_division])
    end
  end

  def bulk_new
    @form = Form::CarCollection.new
  end

  def confirm
    #if request.post?
    @car = Car.new(car_params)
    if @car.invalid?
      @car.save
      flash.now[:danger] = '入力おかしいで'
      render 'new', status: :unprocessable_entity and return
    elsif @car.confirm_list.count > 0
      # それっぽいのがあった場合
      @find_list = @car.confirm_list
    else
      @find_list = @car.confirm_list
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

  def bulk_create
    @form = Form::CarCollection.new(car_collection_params)
    
    before_cnt = Car.count
    if @form.save
      flash[:success] = "#{Car.count - before_cnt}件登録しました。"
      redirect_to cars_bulk_new_path
    else
      flash.now[:danger] = "失敗しました"
      render 'bulk_new', status: :unprocessable_entity and return
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
    if params[:car].nil?
      @car = Car.new
    else
      @car = Car.new(car_params)
      @car_list = @car.find_match.includes(:counter).order("counters.visit_count DESC")
      render 'search' and return
    end
  end

  def import
    unless params[:csv].nil?
      if params[:csv].content_type != "text/csv"
        flash.now[:danger] = "ファイルが不正です"
        render 'import', status: :unprocessable_entity and return
      else
        cnt = Car.count
        Car.import(params[:csv])
        if cnt == Car.count
          flash.now[:danger] = "ファイルが不正です"
          render 'import', status: :unprocessable_entity and return
        end
        redirect_to cars_index_path
      end
    else
      if Car.count > 0
        flash.now[:info] = "車番データがすでに入っています"
      end
    end
  end

  def export    
    respond_to do |format|
      format.html
      format.csv do
        csv_data = Car.export
        csv_name = "export#{Time.now.strftime("%F%T").delete("^0-9")}.csv"
        send_data(csv_data, filename: csv_name)
      end
    end
  end

  def excel_export
    respond_to do |format|
      format.html
      format.xlsx do
        xlsx_data = Car.excel_export
        xlsx_name = "油種#{Time.now.strftime("%F%T").delete("^0-9")}.xlsx"
        send_data(xlsx_data, filename: xlsx_name)
      end
    end
  end

  def countup
    if params['car_id'].present?
      countuped = false
      if params['countuped'] == "false"
        @car = Car.find(params['car_id'])
        if @car.counter == nil
          Counter.create(car:@car)
        end
        @car.counter.countup
      else
        @car = Car.find(params['car_id'])
        @car.counter.countdown
        countuped = true
      end
    end

    render turbo_stream: turbo_stream.replace(
    	"count_buttons_#{@car.id}",
    	partial: 'cars/simple_table_counter',
    	locals: { car: @car, countuped: !(countuped) },
    )

  end

  private

  def car_params
    params.require(:car).permit(:division, :oil_type, :number,
                                :color, :model_mfr, :area,
                                 :hiragana, :class_num, :remarks)
  end

  def car_collection_params
    params.require(:form_car_collection)
    .permit(cars_attributes: [:division, :oil_type, :number,
                                :color, :model_mfr, :area,
                                 :hiragana, :class_num, :remarks])
  end
  
end
