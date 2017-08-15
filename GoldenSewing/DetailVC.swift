//
//  DetailVC.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 31.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    // MARK: - Outlets -
    @IBOutlet weak var imgView: UIImageView!
    
    // MARK: - Properties -
    var product = Product()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set imageView
        imgView.image = UIImage(data: product.featuredImg! as Data)
        imgView.image? = (imgView.image?.imageByAddingRoundCorners(border: 2, color: UIColor.CustomColors.yellow))!

        navigationController?.isNavigationBarHidden = false
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapToBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    func imageByAddingRoundCorners(border borderWidth: CGFloat, color widthColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        let imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: imageRect)
        
        let caLayer = CALayer()
        caLayer.frame = imageRect
        caLayer.contents = self.cgImage
        caLayer.masksToBounds = true
        let temp = self.size.height > self.size.width ? self.size.width : self.size.height
        caLayer.cornerRadius = temp/10
        caLayer.borderWidth = borderWidth
        caLayer.borderColor = widthColor.cgColor
        
        UIGraphicsBeginImageContext(self.size)
        caLayer.render(in: UIGraphicsGetCurrentContext()!)
        
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage!
    }
}
