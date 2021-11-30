# frozen_string_literal: true

class NotificationCallbacks
  def after_create(notification)
    return unless notification.kind == 'mentioned'

    Cache.delete_mentioned_notification_count(notification.user.id)
    Cache.delete_unread_mentioned_notification_count(notification.user.id)
  end

  def after_update(notification)
    return unless notification.kind == 'mentioned' && notification.saved_change_to_attribute?('read')

    Cache.delete_unread_mentioned_notification_count(notification.user.id)
  end

  def after_destroy(notification)
    return unless notification.kind == 'mentioned'

    Cache.delete_mentioned_notification_count(notification.user.id)
    Cache.delete_unread_mentioned_notification_count(notification.user.id) unless notification.read
  end
end
