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
    private let services = ServicesManager()
    
    private override init() {
        super.init()
    }
    
    @objc public func initialize(clientId: String, clientSecret: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
    
    @objc public func identity(id: String, body: [String: Any]) {
        services.identity(id: id, body: body) {result in
            switch result {
            case .success:
                self.identityId = id
                self.identityBody = body
            case .failure(let error):
                print("Identity error: \(error)")
            }
        }
    }
    
    @objc public func clearIdentity() {
        if let identityId = self.identityId {
            services.clearIdentity(id: identityId) {result in
                switch result {
                case .success:
                    self.identityId = nil
                    self.identityBody = nil
                case .failure(let error):
                    print("Clear identity error: \(error)")
                }
            }
        }
        
    }
}
