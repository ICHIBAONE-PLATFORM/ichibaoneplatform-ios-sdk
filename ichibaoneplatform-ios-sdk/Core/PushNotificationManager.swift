//
//  PushNotificationManager.swift
//  ichibaoneplatform-ios-sdk
//
//  Created by Van Huy on 3/4/25.
//
import UIKit
import UserNotifications

public class PushNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    public static let shared = PushNotificationManager()
    
    private(set) var deviceToken: String?
    
    private override init() {
        super.init()
    }
    
    func initialize(useFirebase: Bool) {
        UNUserNotificationCenter.current().delegate = self
    }
    
    public func registerForRemotePushNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            
        }
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        self.updateDeviceToken(deviceToken)
    }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
       print("Failed to register: \(error.localizedDescription)")
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
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
}
