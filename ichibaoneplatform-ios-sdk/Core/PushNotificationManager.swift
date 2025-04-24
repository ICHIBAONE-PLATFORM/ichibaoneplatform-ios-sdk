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
    @objc public var handleForegroundNotification: Bool = false
    
    private(set) var deviceToken: String?
    private let services = ServicesManager()
    private var deeplinkHandler: ((URL) -> Void)?
    
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
    
    @objc public func getDeviceToken() -> String? {
        return self.deviceToken
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

        services.saveToken(deviceToken,payload: payload, isFcmToken: false)
    }
    
    
    @objc public func handleDeeplink(url: URL) {
        self.deeplinkHandler?(url)
    }
    
    @objc public func onDeeplinkReceived(_ handler: @escaping (URL) -> Void) {
        self.deeplinkHandler = handler
    }
}
