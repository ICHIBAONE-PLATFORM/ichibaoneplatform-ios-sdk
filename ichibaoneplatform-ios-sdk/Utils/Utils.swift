//
//  Utils.swift
//  ichibaoneplatform-ios-sdk
//
//  Created by Van Huy on 4/4/25.
//

import UserNotifications

public class Utils {
    public static func downloadImage(from url: URL, completion: @escaping (UNNotificationAttachment?) -> Void) {
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
    
    public static func notificationHelper(request: UNNotificationRequest, contentHandler: @escaping (UNNotificationContent) -> Void) {
            var bestAttemptContent: UNMutableNotificationContent?
            bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent
            
            guard let bestAttemptContent = bestAttemptContent else {
                contentHandler(request.content)
                return
            }
            
            let userInfo = request.content.userInfo
            
            let imageURLString: String? = {
                if let apnsImage = userInfo["image"] as? String {
                    return apnsImage
                }
                return nil
            }()
            
            guard let urlString = imageURLString,
                  let mediaUrl = URL(string: urlString),
                  !urlString.isEmpty else {
                contentHandler(bestAttemptContent)
                return
            }
        
        self.downloadImage(from: mediaUrl) { attachment in
                if let attachment = attachment {
                    bestAttemptContent.attachments = [attachment]
                }
                contentHandler(bestAttemptContent)
            }
        }
}
