//
//  ServicesManager.swift
//  ichibaoneplatform-ios-sdk
//
//  Created by Van Huy on 22/4/25.
//

final class ServicesManager {
    private let baseURL: URL
    
    public static var defaultBaseURL: URL {
        return URL(string: "https://api.ichibaoneplatform")!
    }
    
    public init(baseURL: URL = ServicesManager.defaultBaseURL) {
        self.baseURL = baseURL
    }
    
    func identity(id: String, body: [String: Any], completion: ((Result<Void, Error>) -> Void)?=nil) {
        let endpoint = baseURL.appendingPathComponent("/identity")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var body: [String: Any] = [
                "id": id,
                "body": body
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion?(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion?(.failure(error))
                return
            }
            completion?(.success(()))
        }.resume()
    }
    
    func clearIdentity(id: String, completion: ((Result<Void, Error>) -> Void)?=nil) {
        let endpoint = baseURL.appendingPathComponent("/identity")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion?(.failure(error))
                return
            }
            completion?(.success(()))
        }.resume()
    }

    func saveToken(_ token: String, payload: [String: Any]?=nil, isFcmToken: Bool,  completion: ((Result<Void, Error>) -> Void)?=nil) {
        print("📡 Sending push notification data to server: \(String(describing: payload))")
        let endpoint = baseURL.appendingPathComponent("/token")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var body: [String: Any] = ["token": token, "isFcmToken": isFcmToken, "payload": payload ?? []]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion?(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion?(.failure(error))
                return
            }
            completion?(.success(()))
        }.resume()
    }
    
    func trackEvent(_ event: String, properties: [String: Any]? = nil, completion: ((Result<Void, Error>) -> Void)?=nil) {
        print("📡 Sending track event data to server: \(String(describing: properties))")
        let endpoint = baseURL.appendingPathComponent("/event")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var body: [String: Any] = [
                "event": event
        ]

        if let props = properties {
            body["properties"] = props
        }

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion?(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion?(.failure(error))
                return
            }
            completion?(.success(()))
        }.resume()
    }
}
