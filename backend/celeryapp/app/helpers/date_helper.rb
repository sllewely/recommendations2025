module DateHelper

  def get_date_string(dt)
    # TODO: localize
    "#{dt.month}/#{dt.day}/#{dt.year}"
  end

  def get_time_string(dt)
    _seconds, minutes, hours, *rest = dt.to_a
    "#{hours}:#{minutes < 10 ? '0' : ''}#{minutes}"
  end

end
