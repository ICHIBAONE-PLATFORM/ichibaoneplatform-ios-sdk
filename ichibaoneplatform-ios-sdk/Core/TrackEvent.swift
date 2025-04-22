//
//  TrackEvent.swift
//  ichibaoneplatform-ios-sdk
//
//  Created by Van Huy on 22/4/25.
//

@objcMembers
public class TrackEvent: NSObject {
    @objc public static let shared = TrackEvent()
    private let services = ServicesManager()
    
    private override init() {
        super.init()
    }
    
    @objc public func trackingEvent(name: String, properties: [String: Any]? = nil) {
        //TODO: call api send data to server
        services.trackEvent(name, properties: properties)
    }
}

