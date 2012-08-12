HireFire::Resource.configure do |config|

  config.dyno(:all) do
    HireFire::Macro::Delayed::Job.queue()
  end

end