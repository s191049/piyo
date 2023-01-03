class Car < ApplicationRecord
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
  
  def self.import(csv)
    if CSV.read(csv.path, headers: true, encoding: "cp932:UTF-8")[0].count == 6
      CSV.foreach(csv.path, headers: true, encoding: "cp932:UTF-8") do |row|
        unless Car.where(row.to_h).count > 0
          Car.create(row.to_h)
        end
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

end
