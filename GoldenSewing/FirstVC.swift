//
//  FirstVC.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 31.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class FirstVC: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.startAnimating()
    }
    

    // MARK: - Navigation -
    
    

    // MARK: - Private Methods -
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
