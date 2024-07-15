module LoggingHelper
  def log_runtime(&)
    runtime = Benchmark.realtime(&)

    p "fill_application_form took #{runtime} seconds."
  end
end
