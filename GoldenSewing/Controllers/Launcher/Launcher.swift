//
//  Launcher.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/20/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import Toast_Swift

typealias VCCtor = () -> LaunchControllerDelegate & UIViewController

public class Launcher {
    
    public var pushValue: Int?
    
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
        
        self.controllers = [{GreetingController()}, 
                            {OnboardingView()}]
        self.configureToast()
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
    
    private func configureToast() {
        var style = ToastStyle()
        style.activityBackgroundColor = .clear
        style.activityIndicatorColor = UIColor.CustomColors.yellow
        
        style.backgroundColor = UIColor.CustomColors.burgundy.withAlphaComponent(0.7)
        style.messageColor = UIColor.CustomColors.yellow
        style.messageAlignment = .center
        ToastManager.shared.style = style
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
        vc.modalPresentationStyle = .fullScreen
        navigator.present(vc, animated: false, completion: nil)
    }
    
    private func complete() {
        if (completeLaunch && pushValue == nil) {
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
        
        if let notification = pushValue {
            Router.shared.openDetailView(productId: notification)
        }
    }
}
