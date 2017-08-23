//
//  DetailVC.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 31.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import MessageUI

class DetailVC: UIViewController, UIScrollViewDelegate, MFMailComposeViewControllerDelegate {

    // MARK: - Outlets -
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var ratingView: CosmosView!
    
    // MARK: - Properties -
    var product: Product?
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    var maxScrollHeight: CGFloat {
        return (view.frame.height - view.frame.height/3)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title
        navigationItem.title = "\((product?.name)!), Артикул \((product?.id)!)"
        
        // set imageView
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 20, height: maxScrollHeight))
        imageView.image = UIImage(data: (product?.featuredImg)! as Data)
        imageView.contentMode = .scaleAspectFit
        
        // получаю новый размер сжатой картинки под аспектфит
        let newSize = imageSizeAfterAspectFit(imgView: imageView)
        
        // задаю скроллу нужный фрейм
        //print("view height \(view.frame.height) view height 2|3 \(maxScrollHeight + 60) newSize height \(newSize.height) y == \((maxScrollHeight - newSize.height)/2)")
        scrollView = CustomScroll(frame: CGRect(x: (view.frame.width - newSize.width)/2, y: max(30.0, (maxScrollHeight - newSize.height)/2), width: newSize.width, height: newSize.height))
        scrollView.backgroundColor = .clear
        scrollView.contentSize = newSize
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        
        scrollView.delegate = self
        
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
    
    @IBAction func orderInfBtn(_ sender: UIButton) {
        
        let mailCompose = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setToRecipients(["info@zolotoe-shitvo.kr.ua"])
        mailCompose.setSubject("ЗАКАЗ ИНФОРМАЦИИ по артикулу \(product?.id ?? 777), \(product?.name ?? "noName")")
        mailCompose.setMessageBody("Добрый день! Интересует подробная информация по данному изделию. Сроки и стоимость изготовления. Заранее благодарны.\n\n\nОтправлено из приложения \"Золотое шитье\" v.1.0", isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            
            self.present(mailCompose, animated: true, completion: nil)
            
        } else {
            
            print("Отправка письма: ошибка!")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var str = ""
        switch result {
        case .cancelled:
            str = "Отправка письма была отменена!"
            break
        case .saved:
            str = "Письмо было сохранено!"
            break
        case .sent:
            str = "Письмо было успешно отправлено!"
            break
        case .failed:
            str = "Отправка письма закончилась неудачей!"
            break
        }
        
        let alert = UIAlertController(title: "Сообщение", message: str, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
            
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func orderBtn(_ sender: UIButton) {
        
        guard let number = URL(string: "telprompt://+380505254567") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(number)
        }
    }
    
    
    
    private func didTouchRatingView(_ rating: Double) {
        ratingView.rating = rating
        let productInBD = Product.findProductBy(Int(product!.id))
        productInBD.rating = Int16(rating)

        CoreDataStack.instance.saveContext()
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
