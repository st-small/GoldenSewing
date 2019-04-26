//
//  AboutUsView.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/22/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public class AboutUsView: UIViewController {

    // UI elements
    @IBOutlet private weak var textView: UITextView!
    
    public init() {
        super.init(nibName: "AboutUsView", bundle: Bundle.main)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        
        textView.text = Constants.aboutUs
        textView.font = getFontValue()
        textView.textColor = UIColor.CustomColors.yellow
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.navigationItem.title = "О нас"
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    private func getFontValue() -> UIFont {
        switch UIScreen.main.bounds.width {
        case 320:
            return .systemFont(ofSize: 12.0)
        case 375:
            return .systemFont(ofSize: 13.0)
        case 414:
            return .systemFont(ofSize: 14.0)
        default:
            return .systemFont(ofSize: 11.0)
        }
    }
}
