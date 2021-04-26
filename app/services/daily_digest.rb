class DailyDigest
  def self.call
    return if Question.where(created_at: Date.yesterday.all_day).empty?

    User.find_each(batch_size: 500) { |user| DailyDigestMailer.digest(user).deliver_later }
  end
end
