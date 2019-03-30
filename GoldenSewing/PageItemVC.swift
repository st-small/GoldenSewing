//
//  PageItemVC.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 03.09.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

protocol PageItemVCDelegate {
    func skipTutorial()
}

public class PageItemVC: UIViewController {
    
    // MARK: - Properties -
    var itemIndex: Int = 0
    var contentModel: (String, String) = ("", "") {
        didSet {
            if let imageView = contentImageView {
                imageView.image = UIImage(named: contentModel.0)
            }
            if let label = contentLabel {
                label.text = contentModel.1
            }
        }
    }
    
    var delegate: PageItemVCDelegate!
    
    // MARK: - Outlets -
    @IBOutlet var contentView: UIView?
    @IBOutlet var contentImageView: UIImageView?
    @IBOutlet var contentLabel: UILabel?

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        contentView?.layer.borderColor = UIColor.CustomColors.yellow.cgColor
        contentView?.layer.borderWidth = 1.0
        contentView?.layer.cornerRadius = (contentView?.frame.size.height)!/20
        contentImageView!.image = UIImage(named: contentModel.0)
        contentLabel?.text = contentModel.1
    }
    
    @IBAction func skipTutorial(_ sender: UIButton) {
        delegate.skipTutorial()
    }
}
