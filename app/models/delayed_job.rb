class DelayedJob < ActiveRecord::Base

  scope :by_method_name, lambda{|name| where("handler like ?", "%:#{name}%")}

  # returns collection of values that match a method_name
  #   used when sending a delay_jbo
  # example:
  #   DelayedJob.in_queue('on_create_delay')
  #   returns all entries that have the object.id in table
  def self.in_queue(method_name, column=:id)
    jobs = by_method_name(method_name)
    column_values = jobs.collect do |job|
      info = YAML.load(job.handler)
      info.object[column]
    end
    column_values
  end
end