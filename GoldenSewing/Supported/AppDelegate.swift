//
//  AppDelegate.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 27.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Firebase
import UserNotifications
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var launcher: Launcher?
    
    let center = UNUserNotificationCenter.current()
    let application = UIApplication.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        
        registerOneSignal(launchOptions)
        
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
        
        registerPushNotifications()
        
        let launcher = Launcher(for: self, with: launchOptions)
        self.launcher = launcher
        
        self.window = launcher.window
        launcher.start()
        
        let realmFilePath = Realm.Configuration.defaultConfiguration.fileURL
        print("Realm File Path", realmFilePath!)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }


}

