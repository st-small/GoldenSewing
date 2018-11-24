//
//  Launcher.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/20/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

typealias VCCtor = () -> LaunchControllerDelegate & UIViewController

public class Launcher {
    
    private var completeLaunch: Bool = false
    private var completeHandler: Trigger? = nil
    
    private var delegate: UIApplicationDelegate
    private var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    private var navigator: NavigationController
    private let controllers: [VCCtor]
    
    public init(for delegate: UIApplicationDelegate, with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        self.delegate = delegate
        self.launchOptions = launchOptions
        
        self.navigator = NavigationController()
        navigator.setNavigationBarHidden(true, animated: false)
        
        self.controllers = [{GreetingController()}, 
                            {TutorialPageVC()}]
    }
    
    public var window: UIWindow {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigator
        window.makeKeyAndVisible()
        window.backgroundColor = UIColor.CustomColors.burgundy
        
        return window
    }
    
    public func start() {
        continueLaunch(from: 0)
    }
    
    private func continueLaunch(from step: Int) {
        
        if (step >= controllers.count) {
            self.complete()
            return
        }
        
        let ctor = controllers[step]
        var vc = ctor()
        let nextStep = step + 1
        
        if (vc.notNeedDisplay) {
            vc.hiddenProcessing()
            continueLaunch(from: nextStep)
            return
        }
        
        vc.onCompleteHandler = {
            self.continueLaunch(from: nextStep)
        }
        
        if let old = navigator.presentedViewController {
            old.dismiss(animated: false, completion: {
                self.display(vc)
            })
        }
        else {
            display(vc)
        }
    }
    
    private func display(_ vc: UIViewController) {
        navigator.present(vc, animated: false, completion: nil)
    }
    
    private func complete() {
        if (completeLaunch) {
            return
        }
        
        completeLaunch = true
        
        if let old = self.navigator.presentedViewController {
            old.dismiss(animated: false, completion: nil)
        }
        
        let tabs = CustomTabBarController()
        let navigator = NavigationController(rootViewController: tabs)
        self.navigator = navigator
        Router.shared.navigator = navigator
        Router.shared.tabs = tabs
        
        self.delegate.window??.rootViewController = navigator
        
        self.processTappedPush()
        
        self.completeHandler?()
    }
    
    public func processTappedPush() {
        
        if (!completeLaunch) {
            return
        }
    }
}
