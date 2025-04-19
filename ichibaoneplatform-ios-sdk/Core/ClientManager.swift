//
//  ClientManager.swift
//  ichibaoneplatform-ios-sdk
//
//  Created by Van Huy on 19/4/25.
//
@objcMembers
public class ClientManager: NSObject {
    @objc public static let shared = ClientManager()
    
    private var clientId: String?
    private var clientSecret: String?
    private var identityId: String?
    private var identityBody: [String: Any]?
    
    private override init() {
        super.init()
    }
    
    @objc public func initialize(clientId: String, clientSecret: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
    
    @objc public func identity(id: String, body: [String: Any]) {
        self.identityId = id
        self.identityBody = body
        //TODO: call api send data to server
    }
    
    @objc public func clearIdentity() {
        self.identityId = nil
        self.identityBody = nil
        //TODO: clear in server
    }
    
    @objc public func trackingEvent(name: String, properties: [String: Any]? = nil) {
        //TODO: call api send data to server
    }
}
