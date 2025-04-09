//
//  InAppNotificationManager.swift
//  ichibaoneplatform-ios-sdk
//
//  Created by Van Huy on 3/4/25.
//

import UIKit

@objcMembers
public class InAppNotificationManager: NSObject {
    @objc public static let shared = InAppNotificationManager()

    private override init() {}

    @objc public func showNotification(title: String, message: String) {
        guard let windowScene = UIApplication.shared.connectedScenes
               .compactMap({ $0 as? UIWindowScene })
               .first,
             let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
             let rootViewController = keyWindow.rootViewController else {
           return
       }

       let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "OK", style: .default))

       DispatchQueue.main.async {
           rootViewController.present(alert, animated: true)
       }
    }
}
