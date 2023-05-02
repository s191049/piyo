module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'にいがたエネルギー'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def posts_per_page
    20
  end

  def boards_per_page
    8
  end

  def app_ver
    File.read("#{Rails.root}/VERSION").chomp
  end

end
