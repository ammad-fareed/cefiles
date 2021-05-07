module AdminHelper
  def format_date_time(datetime)
    datetime.strftime("%B %d, %Y  %I:%M%p")
  end
end