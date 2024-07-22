module LoggingHelper
  def log_runtime(method_name)
    runtime = Benchmark.realtime { send(method_name) }
    puts "#{method_name} took #{runtime} seconds."
  end
end
