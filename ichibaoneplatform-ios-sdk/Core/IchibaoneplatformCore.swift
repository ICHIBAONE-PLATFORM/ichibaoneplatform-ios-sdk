//
//  Core.swift
//  ichibaoneplatform-ios-sdk
//
//  Created by Van Huy on 24/4/25.
//

//
//  IchibaoneplatformSdk.swift
//  ichibaoneplatform-ios-sdk
//
//  Created by Van Huy on 24/4/25.
//

public class IchibaoneplatformCore: NSObject {
    @objc public static let clientManager: ClientManager = ClientManager.shared
    @objc public static let localNotificationManager: LocalNotificationManager = LocalNotificationManager.shared
    @objc public static let inAppNotificationManager: InAppNotificationManager = InAppNotificationManager.shared
    @objc public static let trackEvent: TrackEvent = TrackEvent.shared
}
