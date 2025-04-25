//
//  LocalNotification.swift
//  ichibaoneplatform-ios-sdk
//
//  Created by Van Huy on 2/4/25.
//
import UserNotifications

@objcMembers
public class LocalNotificationManager: NSObject {
    @objc public static let shared = LocalNotificationManager()
    private override init() {}
    
    @objc public func requestPermission(completion: ((Bool, Error?) -> Void)? = nil) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                completion?(granted, error)
            }
        }
    }
    
    @objc public func scheduleNotification(title: String,
                                           body: String,
                                           timeInterval: TimeInterval = 0.1,
                                           userInfo: [String: Any]? = nil)  {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        if let userInfo = userInfo {
            content.userInfo = userInfo
            
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        if let image = userInfo?["image"] as? String, let imageUrl = URL(string: image) {
            Utils.downloadImage(from: imageUrl) { attachment in
                if let attachment = attachment {
                    content.attachments = [attachment]
                }
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
            
        } else {
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    /// Cancel all scheduled local notifications
    @objc public func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    /// Cancel notification by identifier
    @objc public func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
