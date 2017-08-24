//
//  ContactsVC.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 24.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import MapKit
import MessageUI

class ContactsVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate {
    
    // MARK: - Outlets -
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties -
    var isTouched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        label.text = "Мы находимся в Украине по адресу:\n25006, г. Кировоград, ул.Михайловская, 73,\nХПП «Золотое шитье»."
        
        // set mapView
        
        mapView.delegate = self
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("город Кировоград, улица Михайловская, 73") { (placemarks, error) in
            
            guard error == nil else { return }
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first!
            
            let annotation = MKPointAnnotation()
            annotation.title = "ХПП «Золотое шитье»"
            annotation.subtitle = "Ручная и машинная вышивка"
            
            guard let location = placemark.location else { return }
            annotation.coordinate = location.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
            
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(ContactsVC.openMapApp(recognizer:)))
        mapView.addGestureRecognizer(tapRecognizer)
        
    }
    
    func openMapApp(recognizer: UITapGestureRecognizer) {
        let latitude: CLLocationDegrees = 48.504931
        let longitude: CLLocationDegrees = 32.269919
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let placemarkMap = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let mapItem = MKMapItem(placemark: placemarkMap)
        mapItem.name = "ХПП «Золотое шитье»"
        mapItem.openInMaps(launchOptions: options)
    }
    
    @IBAction func mailBtn(_ sender: UIButton) {
        
        let mailCompose = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setToRecipients(["info@zolotoe-shitvo.kr.ua"])
        mailCompose.setSubject("Предварительный запрос")
        mailCompose.setMessageBody("Добрый день! Интересует подробная информация ...\n\n\nОтправлено из приложения \"Золотое шитье\" v.1.0", isHTML: false)
        
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
    
    @IBAction func callBtn(_ sender: UIButton) {
        
        guard let number = URL(string: "telprompt://+380505254567") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(number)
        }
    }

}
