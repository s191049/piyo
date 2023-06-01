class Car < ApplicationRecord
  has_one :counter, dependent: :destroy
  
  # 油種は必須 enum 数値範囲は後ほど指定予定
  enum oil_type: { diesel: 0, gasoline: 1 }
  validates :oil_type, presence: true

  # 区分(国産SUV・1BOX/マツダ･･････)は必須 enum
  enum division: { japanese: 0, mazda: 1, benz: 2, bmw: 3, foreign: 4 }
  validates :division, presence: true

  # 車番は必須 int型1〜9999まで
  validates :number, numericality: { in: 1..9999 }

  # 色は任意 string
  # validates :color, allow_nil: true

  # 車種メーカーは任意 string
  # validates :model_mfr, allow_nil: true

  # 地域名は任意 string
  # validates :area, allow_nil: true

  # ひらがなは任意 string をしへん以外のひらがな1文字
  HIRAGANA_LIST = %w[あ い う え お
                     か き く け こ
                     さ す せ そ
                     た ち つ て と
                     な に ぬ ね の
                     は ひ ふ ほ
                     ま み む め も
                     や ゆ よ
                     ら り る れ ろ
                     わ]
  validates :hiragana, length: { is: 1 }, allow_blank: true,
                       inclusion: { in: HIRAGANA_LIST }

  # 分類番号は任意 string 数字とアルファベットの組み合わせ3文字
  VALID_CLASS_NUM_REGEX = /\A[0-9][A-Z0-9]{2}\z/i
  validates :class_num, allow_blank: true,
                        format: { with: VALID_CLASS_NUM_REGEX }

  # 備考は任意
  # validates :remarks, allow_nil: true

  def find_match
    search_hash = attributes.delete_if { |_k, v| v.blank? }
    Car.where(search_hash)
  end
  
  def confirm_list
    Car.where(number: self.number, division: self.division, oil_type: self.oil_type)
  end
  
  def simple_etc
    [self.model_mfr, self.area, self.hiragana, self.class_num, self.remarks].compact_blank
  end

  def search_conditions
    [self.division_i18n, self.number].compact_blank.join(" ")
  end
  
  def self.import(csv)
    cnt = Car.count
    if CSV.read(csv.path, headers: true, encoding: "cp932:UTF-8")[0].count == 6
      CSV.foreach(csv.path, headers: true, encoding: "cp932:UTF-8") do |row|
        unless Car.where(row.to_h).count > 0
          Car.create(row.to_h)
        end
      end
    elsif CSV.read(csv.path, headers: true, encoding: "cp932:UTF-8")[0].count == 12
      CSV.foreach(csv.path, headers: true, encoding: "cp932:UTF-8") do |row|
        unless Car.where(row.to_h).count > 0
          Car.create(row.to_h.reject{ |key| "id" == key })
        end
      end
    end
  end

  def self.delete_all
    cars = Car.all
    ActiveRecord::Base.transaction do
      cars.each do |car|
        car.destroy!
      end
    end
  end
  
  def self.export
    csv_data = CSV.generate(encoding: Encoding::CP932) do |csv|
      csv << array_cp932(Car.attribute_names)
      (1..9).each do |i|
        Car.where("number LIKE ?", "#{i}%").order(number: :ASC).each do |car|
          csv << array_cp932(car.attributes.values)
        end
      end
    end
    csv_data
  end

  
  def self.array_cp932(array)
    new_array = array.map { |s|
      s = s.to_s
      s.encode("CP932")
    }
    new_array
  end

  GREEN = "548235"
  RED = "FF0000"
  FONT = '游ゴシック'
  FONT_SIZE = 11
  COL_MAX = 36

  def self.excel_export

    workbook = RubyXL::Parser.parse(Rails.root + "app/assets/excels/base.xlsx")
    #国産車
    (1..9).each do |i|
      (-1..9).each do |j|
        japanese_cars = pick_cars(i,j,0)
        mazda_cars = pick_cars(i,j,1)
        sheet_count = [japanese_cars.count, mazda_cars.count].max
        (0...sheet_count).each do |k|
          #シートコピー
          sheet_name = name_sheet(true, i, j)
          if k > 0
            sheet_name = sheet_name + "-#{k}"
          end
          workbook = copy_sheet(workbook, sheet_name, true)
          worksheet = workbook[sheet_name]

          #cell挿入
          unless japanese_cars[k].nil?
            worksheet = insert_cells(worksheet, japanese_cars[k])
          end
          unless mazda_cars[k].nil?
            worksheet = insert_cells(worksheet, mazda_cars[k])
          end
        end
      end
    end
    #外車
    (1..9).each do |i|
      (-1..9).each do |j|
        benz_cars = pick_cars(i,j,2)
        bmw_cars = pick_cars(i,j,3)
        foreign_cars = pick_cars(i,j,4)
        sheet_count = [benz_cars.count, bmw_cars.count, foreign_cars.count].max
        (0...sheet_count).each do |k|
          #シートコピー
          sheet_name = name_sheet(false, i, j)
          if k > 0
            sheet_name = sheet_name + "-#{k}"
          end
          workbook = copy_sheet(workbook, sheet_name, false)
          worksheet = workbook[sheet_name]

          #cell挿入
          unless benz_cars[k].nil?
            worksheet = insert_cells(worksheet, benz_cars[k])
          end
          unless bmw_cars[k].nil?
            worksheet = insert_cells(worksheet, bmw_cars[k])
          end
          unless foreign_cars[k].nil?
            worksheet = insert_cells(worksheet, foreign_cars[k])
          end
        end
      end
    end
    data = workbook.stream.read
    return data
  end

  def self.test_pick
    p pick_cars(3,-1,"benz")
  end

  def merge_remarks_for_excel
    [self.area, self.hiragana, self.class_num, self.remarks].compact_blank.join(" ")
  end


  private

  def self.copy_sheet(workbook, sheet_name, is_japanese)
    #tes
    if is_japanese
      template = workbook['国白紙']
    else
      template = workbook['外白紙']
    end
    worksheet = workbook.add_worksheet(sheet_name)
    worksheet.sheet_data = template.sheet_data.dup
    worksheet.sheet_data.rows = template.sheet_data.rows.map do |row|
      next unless row
      new_row = row.dup
      new_row.worksheet = worksheet
      new_row.cells = row.cells.map{ |cell| next unless cell; new_cell = cell.dup; new_cell.worksheet = worksheet; new_cell }
      new_row
    end
    worksheet.cols = Marshal.load(Marshal.dump(template.cols))
    worksheet.merged_cells = Marshal.load(Marshal.dump(template.merged_cells))
    return workbook
  end

  def self.pick_cars(ini_num, turn_num, target_div)
    targets_array = []
    if turn_num == -1
      targets = Car.order(:number, :asc).where("number < 1000").where("number LIKE ?", "#{ini_num}%").where(division: target_div)
    else
      targets = Car.order(:number, :asc).where("number >= #{ini_num*1000}").where("number LIKE ?", "#{ini_num*10+turn_num}%").where(division: target_div)
    end
    for i in 0..((targets.count - 1)/COL_MAX)
      targets_array[i] = []
    end
    targets.each_with_index do |tar, i|
      targets_array[i / COL_MAX] << tar
    end
    return targets_array
  end

  def self.name_sheet(is_japanese, ini_num, cnt_num)
    sheet_name = ''
    if is_japanese
      sheet_name = '国'
    else
      sheet_name = '外'
    end
    if cnt_num == -1
      sheet_name = sheet_name + 0.to_s + ini_num.to_s
    else
      sheet_name = sheet_name + "#{ini_num * 10 + cnt_num}"
    end
    return sheet_name
  end

  def self.insert_cells(worksheet, target_cars)
    start_col = -1
    case target_cars.first.division
    when "japanese" then
      start_col = 0
    when "mazda" then
      start_col = 4
    when "benz" then
      start_col = 0
    when "bmw" then
      start_col = 4
    when "foreign" then
      start_col = 8
    end
    for i in 0...target_cars.count
      font_color = RED
      if target_cars[i].oil_type == "diesel"
        font_color = GREEN
      end
      cell_style_index = Array.new(4)
      for j in 0...4
        cell_style_index[j] = worksheet[i+2][start_col+j].style_index.deep_dup
      end
      worksheet.add_cell(i+2,start_col,format("%04d",target_cars[i].number))
      worksheet.add_cell(i+2,start_col+1,target_cars[i].color)
      worksheet.add_cell(i+2,start_col+2,target_cars[i].model_mfr)
      worksheet.add_cell(i+2,start_col+3,target_cars[i].merge_remarks_for_excel)
      for j in 0...4
        worksheet[i+2][start_col+j].style_index = cell_style_index[j]
        worksheet[i+2][start_col+j].change_font_name FONT
        worksheet[i+2][start_col+j].change_font_size FONT_SIZE
        worksheet[i+2][start_col+j].change_font_color(font_color)
      end
    end
    return worksheet
  end


end
