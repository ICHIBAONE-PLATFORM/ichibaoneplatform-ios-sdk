//
//  Utils.swift
//  ichibaoneplatform-ios-sdk
//
//  Created by Van Huy on 4/4/25.
//

import UserNotifications

@objcMembers
public class Utils: NSObject {
    @objc public static func downloadImage(from url: URL, completion: @escaping (UNNotificationAttachment?) -> Void) {
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
    
    @objc public static func notificationHelper(request: UNNotificationRequest, contentHandler: @escaping (UNNotificationContent) -> Void) {
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
                
                if let fcmOptions = userInfo["fcm_options"] as? [String: Any],
                   let fcmImage = fcmOptions["image"] as? String {
                    return fcmImage
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
