# frozen_string_literal: true

module TaskList
  def add_derived_value(derived_value)
    raise ArgumentError if derived_value.nil?

    derived_value.parent = self
    derived_values << derived_value
  end

  def add_task(task)
    tasks << task
  end

  def derived_values
    @derived_values ||= []
  end

  def filter_tasks(with_derived:)
    if with_derived
      tasks + derived_values
    else
      tasks
    end
  end

  def tasks
    @tasks ||= []
  end
end
