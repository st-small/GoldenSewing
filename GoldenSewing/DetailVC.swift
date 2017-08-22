//
//  DetailVC.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 31.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class DetailVC: UIViewController, UIScrollViewDelegate {
<<<<<<< HEAD

=======
    
>>>>>>> 036f68613112e918be851d7c3f8e852ceb135cc5
    // MARK: - Outlets -
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    
    // MARK: - Properties -
    var product: Product?
<<<<<<< HEAD
    var scrollView: UIScrollView!
    
=======
    var imageView: UIImageView!
    var scrollView: UIScrollView!
>>>>>>> 036f68613112e918be851d7c3f8e852ceb135cc5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title
        navigationItem.title = "\((product?.name)!), Артикул \((product?.id)!)"
        
        // set imageView
<<<<<<< HEAD
        imgView.image = UIImage(data: (product?.featuredImg)! as Data)
        imgView.image? = (imgView.image?.imageByAddingRoundCorners(border: 2, color: UIColor.CustomColors.yellow))!

=======
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 20, height: view.frame.height - view.frame.height/3))
        imageView.image = UIImage(data: product?.featuredImg as! Data)
        imageView.contentMode = .scaleAspectFit
        
        // получаю новый размер сжатой картинки под аспектфит
        let newSize = imageSizeAfterAspectFit(imgView: imageView)
        
        // задаю скроллу нужный фрейм
        scrollView = CustomScroll(frame: CGRect(x: (view.frame.width - newSize.width)/2, y: 60, width: newSize.width, height: newSize.height))
        scrollView.backgroundColor = .clear
        scrollView.contentSize = newSize
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        
        scrollView.delegate = self
        
>>>>>>> 036f68613112e918be851d7c3f8e852ceb135cc5
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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("\(imageView.frame.size)")
        imageView.frame.size = imageSizeAfterAspectFit(imgView: imageView)
        return imageView
    }
    
    func imageSizeAfterAspectFit(imgView: UIImageView) -> CGSize {
        
        var newWidth: CGFloat = 0
        var newHeight: CGFloat = 0
        var diff: CGFloat = 0
        
        let image = imgView.image!
        
        if (image.size.height >= image.size.width) {
            newHeight = imgView.frame.size.height
            newWidth = (image.size.width/image.size.height)*newHeight
            
            if (newWidth > imgView.frame.size.width) {
                diff = imgView.frame.size.width - newWidth
                newHeight = newHeight + diff / newHeight * newHeight
                newWidth = imgView.frame.size.width
            }
            
        } else {
            newWidth = imgView.frame.size.width;
            newHeight = (image.size.height/image.size.width) * newWidth
            
            if (newHeight > imgView.frame.size.height){
                diff = imgView.frame.size.height - newHeight
                newWidth = newWidth + diff / newWidth * newWidth
                newHeight = imgView.frame.size.height;
            }
        }
        
        //print("image after aspect fit: width = \(newWidth) height = \(newHeight)")
        
        return CGSize(width: newWidth, height: newHeight)
    }
    
    
    @IBAction func tapToBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pinchImage(_ sender: UIPinchGestureRecognizer) {
        let lastScaleFactor:CGFloat = 1
        let factor:CGFloat = sender.scale
        if (factor > 1) {
            imgView.transform = CGAffineTransform(scaleX: (lastScaleFactor + (factor - 1)), y: lastScaleFactor + (factor - 1))
            
        } else {
            imgView.transform = CGAffineTransform(scaleX: lastScaleFactor * factor, y: lastScaleFactor * factor)
        }
    
    }
    
    private func didTouchRatingView(_ rating: Double) {
        ratingView.rating = rating
        let productInBD = Product.findProductBy(Int(product!.id))
        productInBD.rating = Int16(rating)
<<<<<<< HEAD

        CoreDataStack.instance.saveContext()
=======
        
        try? CoreDataStack.instance.saveContext()
>>>>>>> 036f68613112e918be851d7c3f8e852ceb135cc5
        
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
