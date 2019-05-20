//
//  GreetingController.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/20/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public class GreetingController: UIViewController {
    
    @IBOutlet private var activity: UIActivityIndicatorView!
    
    public var onCompleteHandler: Trigger?
    
    private let properties = UserDefaults.standard
    
    public init() {
        super.init(nibName: "GreetingController", bundle: Bundle.main)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        activity = UIActivityIndicatorView(style: .whiteLarge)
        
        DispatchQueue.main.async { [weak self] in
            
            guard let this = self else {
                return
            }
            
            this.activity.startAnimating()
        }
        
        simulateSomethingProcessing() 
    }
    
    private func simulateSomethingProcessing() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            
            guard let this = self else { return }
            this.onCompleteHandler?()
        }
    }
}

extension GreetingController: LaunchControllerDelegate {
    public var notNeedDisplay: Bool {
        return false
    }
}
