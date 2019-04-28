module AttendancesHelper
  def current_time
    Time.new(
      Time.new.year,
      Time.new.month,
      Time.new.day,
      Time.new.hour,
      Time.new.min,0
      )
  end

  def working_times(started_at, finished_at)
    format("%.2f", (((finished_at - started_at) / 60) / 60.0))
  end

  def working_times_sum(seconds)
    format("%.2f", seconds / 60 / 60.0 )
  end
end