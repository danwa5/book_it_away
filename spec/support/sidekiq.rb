require 'sidekiq/testing'

Sidekiq::Queue.class_eval do
  def jobs
    jobs = []
    each { |j| jobs << j }
    jobs
  end
end

require 'sidekiq/testing'
RSpec.configure do |config|
  config.before(:each) do | example |
    # Clears out the jobs for tests using the fake testing
    Sidekiq::Worker.clear_all

    if example.metadata[:sidekiq] == :fake
      Sidekiq::Testing.fake!
    elsif example.metadata[:sidekiq] == :inline
      Sidekiq::Testing.inline!
    else
      Sidekiq::Testing.fake!
    end
  end
end