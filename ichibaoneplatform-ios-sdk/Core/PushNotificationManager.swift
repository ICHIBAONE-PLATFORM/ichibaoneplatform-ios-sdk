//
//  PushNotificationManager.swift
//  ichibaoneplatform-ios-sdk
//
//  Created by Van Huy on 3/4/25.
//
import UIKit
import UserNotifications

@objcMembers
public class PushNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    @objc public static let shared = PushNotificationManager()
    
    private(set) var deviceToken: String?
    
    private override init() {
        super.init()
    }
    
    @objc public func initialize() {
        UNUserNotificationCenter.current().delegate = self
    }
    
    @objc public func registerForRemotePushNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            
        }
    }
    
    @objc public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.updateDeviceToken(deviceToken)
    }

    @objc public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
       print("Failed to register: \(error.localizedDescription)")
    }

    // Handle foreground notification
    @objc public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }

    // Handler user press notification
    @objc public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        handleNotification(userInfo: userInfo)
        completionHandler()
    }
    
    func updateDeviceToken(_ token: Data) {
        let tokenString = token.map { String(format: "%02x", $0) }.joined()
        self.deviceToken = tokenString
        sendTokenToServer()
    }

    
    /// Gửi dữ liệu lên server
    private func sendTokenToServer(userID: String? = nil) {
        guard let deviceToken = deviceToken else { return }

        var payload: [String: Any] = [
            "device_token": deviceToken,
            "platform": "iOS"
        ]
        
        if let userID = userID {
            payload["user_id"] = userID
        }

        // Giả lập gửi request lên server
        sendToServer(payload: payload)
    }
    
    /// Mock gửi lên server
    private func sendToServer(payload: [String: Any]) {
        print("📡 Sending push notification data to server: \(payload)")
    }
    
    func handleNotification(userInfo: [AnyHashable: Any]) {
        if let deeplink = userInfo["deeplink"] as? String,
           let url = URL(string: deeplink) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
