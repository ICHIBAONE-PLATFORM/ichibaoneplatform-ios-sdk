//
//  Utils.swift
//  ichibaoneplatform-ios-sdk
//
//  Created by Van Huy on 4/4/25.
//

import UserNotifications

public class Utils {
    public init() {}
    public func downloadImage(from url: URL, completion: @escaping (UNNotificationAttachment?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { (location, _, error) in
            guard let location = location, error == nil else {
                completion(nil)
                return
            }
            
            let tempDirectory = FileManager.default.temporaryDirectory
            let newFileURL = tempDirectory.appendingPathComponent(url.lastPathComponent)
            
            do {
                try FileManager.default.moveItem(at: location, to: newFileURL)
                let attachment = try UNNotificationAttachment(identifier: UUID().uuidString, url: newFileURL, options: nil)
                completion(attachment)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
}
