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
    
    @objc public func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            completion(granted)
        }
    }
    
    @objc public func scheduleNotification(title: String, body: String, timeInterval: TimeInterval = 0.1) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
