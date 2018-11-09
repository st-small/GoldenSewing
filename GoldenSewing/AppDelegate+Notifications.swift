//
//  AppDelegate+Notifications.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 26.10.2018.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

extension AppDelegate {
    
    func registerPushNotifications() {
       
        center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in 
            
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        center.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async { [weak self] in
                
                guard let this = self else {
                    return
                }
                this.application.registerForRemoteNotifications()
            } 
        }
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(token)")
        //let service = ExchangeService()
        //service.registerPushToken(token: token)
    }
    
    // MARK: - Notifications processing
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("didReceiveRemoteNotification applicationState:", application.applicationState.rawValue)
    }
    
    // MARK: - Private
    
    private func handleRemoteNotification(userInfo: [AnyHashable : Any], switchScreen: Bool) {
        guard let text = notificationText(userInfo: userInfo) else {
            return
        }
        print(text)
    }
    
    private func notificationText(userInfo: [AnyHashable : Any]) -> String? {
        guard let apsData = userInfo["aps"] as? [String : AnyObject] else { return nil }
        var alertText: String? = apsData["alert"] as? String
        guard let alertData = apsData["alert"] as? [String: AnyObject] else { return alertText }
        
        var result = ""
        if let title = alertData["title"] as? String {
            result += title
        }
        if let body = alertData["body"] as? String {
            if !result.isEmpty { result += ". " }
            result += body
        }
        if !result.isEmpty {
            alertText = result
        }
        return alertText
    }
}
