//
//  PushNotificationManagerFCM.swift
//  ichibaoneplatform-ios-sdk
//
//  Created by Van Huy on 8/4/25.
//

import UIKit
import UserNotifications
import FirebaseMessaging

@objcMembers
public class PushNotificationManagerFCM: NSObject, UNUserNotificationCenterDelegate, MessagingDelegate {
    @objc public static let shared = PushNotificationManagerFCM()
    @objc public var handleForegroundNotification: Bool = false
    
    private(set) var fcmToken: String?
    private let services = ServicesManager()
    private var deeplinkHandler: ((URL) -> Void)?

    private override init() {
        super.init()
    }
    
    @objc public func initialize() {
        Messaging.messaging().delegate = self
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
        Messaging.messaging().apnsToken = deviceToken
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
        if handleForegroundNotification {
            completionHandler([.banner, .sound, .badge])
        } else {
            completionHandler([])
        }
    }

    // Handler user press notification
    @objc public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        if let deeplinkString = userInfo["deeplink"] as? String,
           let deeplinkURL = URL(string: deeplinkString) {
            deeplinkHandler?(deeplinkURL)
        }
        completionHandler()
    }
    
    @objc public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        self.fcmToken = fcmToken
        self.sendTokenToServer()
    }
    
    @objc public func getFcmToken() async -> String? {
        if let currentToken = self.fcmToken {
            return currentToken
        }

        return await withCheckedContinuation { continuation in
            Messaging.messaging().token { token, error in
                if let token = token {
                    self.fcmToken = token
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
            
    }
    

    /// Gửi dữ liệu lên server
    private func sendTokenToServer(userID: String? = nil) {
        guard let fcmToken = fcmToken else { return }

        var payload: [String: Any] = [
            "fcm_token": fcmToken,
            "platform": "iOS"
        ]
        
        if let userID = userID {
            payload["user_id"] = userID
        }

        services.saveToken(fcmToken,payload: payload, isFcmToken: false)
    }
    
    @objc public func handleDeeplink(url: URL) {
        self.deeplinkHandler?(url)
    }
    
    @objc public func onDeeplinkReceived(_ handler: @escaping (URL) -> Void) {
        self.deeplinkHandler = handler
    }
}
