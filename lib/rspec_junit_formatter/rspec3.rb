class RSpecJUnitFormatter < RSpec::Core::Formatters::BaseFormatter
  RSpec::Core::Formatters.register self,
    :start,
    :example_failed,
    :stop,
    :dump_summary

  def start(notification)
    @start_notification = notification
    @started = Time.now
    super
  end

  def example_failed(notification)
  end

  def stop(notification)
    @examples_notification = notification
  end

  def dump_summary(notification)
    @summary_notification = notification
    xml_dump
  end

private

  attr_reader :started

  def example_count
    @summary_notification.examples.count
  end

  def failure_count
    @summary_notification.failed_examples.count
  end

  def duration
    @summary_notification.duration
  end

  def examples
    @examples_notification.notifications
  end

  def result_of(notification)
    notification.example.execution_result.status
  end

  def example_group_file_path_for(notification)
    notification.example.example_group.file_path
  end

  def classname_for(notification)
    fp = example_group_file_path_for(notification)
    fp.sub(%r{\.[^/]*\Z}, "").gsub("/", ".").gsub(%r{\A\.+|\.+\Z}, "")
  end

  def duration_for(notification)
    notification.example.execution_result.run_time
  end

  def description_for(notification)
    notification.example.full_description
  end

  def exception_for(notification)
    notification.fully_formatted(0).split("\n").second
  end

  def formatted_backtrace_for(notification)
    notification.fully_formatted(0).split("\n")[2..-1].join("\n")
  end
end
