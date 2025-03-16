module DateHelper

  def get_date_string(dt)
    # TODO: localize
    "#{dt.month}/#{dt.day}/#{dt.year}"
  end

  def get_time_string(dt)
    seconds, minutes, hours, *rest = dt.to_a
    "#{hours}:#{minutes < 10 ? '0' : ''}#{minutes}:#{seconds < 10 ? '0' : ''}#{seconds}"
  end

end
