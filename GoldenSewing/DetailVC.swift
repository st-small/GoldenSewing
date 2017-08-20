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
    @IBOutlet weak var ratingView: CosmosView!
    
    // MARK: - Properties -
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title
        navigationItem.title = "\((product?.name)!), Артикул \((product?.id)!)"
        
        // set imageView
        imgView.image = UIImage(data: product?.featuredImg! as! Data)
        imgView.image? = (imgView.image?.imageByAddingRoundCorners(border: 2, color: UIColor.CustomColors.yellow))!
        
        // set ratingView
        if product?.rating != 0 {
            ratingView.rating = Double((product?.rating)!)
        } else {
            ratingView.rating = 0
        }
        
        ratingView.didTouchCosmos = didTouchRatingView
        
        // set custom back button
        let customButton = UIBarButtonItem(image: UIImage(named: "back button"), style: .plain, target: self, action: nil)
        customButton.tintColor = .clear
        self.navigationItem.leftBarButtonItem = customButton
        
        // set custom back button2
        let customButton2 = UIBarButtonItem(image: UIImage(named: "back button"), style: .plain, target: self, action: nil)
        customButton2.tintColor = .clear
        self.navigationItem.rightBarButtonItem = customButton2

        navigationController?.isNavigationBarHidden = false
       
    }

    
    @IBAction func tapToBack(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    private func didTouchRatingView(_ rating: Double) {
        ratingView.rating = rating
        let productInBD = Product.findProductBy(Int(product!.id))
        productInBD.rating = Int16(rating)

        try? CoreDataStack.instance.saveContext()
        
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
