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
import OneSignal

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    public func registerOneSignal(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "1f610cbc-3ea7-49ad-8d7c-bc4f0dae4fe8",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
    }
    
    public func registerPushNotifications() {
        
        center.delegate = self
        center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in 
            
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    public func getNotificationSettings() {
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
    
    public func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(token)")
    }
    
    // MARK: - Notifications processing
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .alert])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void)  {
        if let userInfo = response.notification.request.content.userInfo as? [String : AnyObject] {
            guard let value = notificationTextCheckVendor(userInfo: userInfo) else { return }
            if (UIApplication.shared.applicationState == .inactive) {
                // recieved push in background
                launcher?.pushValue = value
                launcher?.start()
            } else {
                // recieved push in foreground
                Router.shared.openDetailView(productId: value)
            }
        }
        completionHandler()
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
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
    
    private func notificationTextCheckVendor(userInfo: [AnyHashable : Any]) -> Int? {
        print("user info \(userInfo)")
        guard let custom = userInfo["custom"] as? [String : Any],
            let aValue =  custom["a"] as? [String : Any],
            let vendor = aValue["vendorCode"] as? String else { return nil }
        return Int(vendor)
    }
}
