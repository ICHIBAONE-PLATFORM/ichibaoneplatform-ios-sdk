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
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        keyWindow.rootViewController?.present(alert, animated: true)
    }
}
