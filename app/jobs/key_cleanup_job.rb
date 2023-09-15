class KeyCleanupJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    # invoke another job at your time of choice 
    self.class.set(:wait => 10.seconds).perform_later(job.arguments.first)
  end

  def perform(*args)
    KeyStoreHelper::BLOCKED_KEYS.purgeOld(60000)
    KeyStoreHelper::AVAILABLE_KEYS.purgeOld(300000)
  end

  def KeyCleanupJob.start
    self.perform_later
  end
end
