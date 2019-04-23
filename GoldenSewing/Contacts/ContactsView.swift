//
//  ContactsView.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/22/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import MapKit
import MessageUI
import Toast_Swift

public class ContactsView: UIViewController {
    
    // UI elements
    @IBOutlet private weak var descriptionText: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var webAction: UIButton!
    @IBOutlet private weak var phoneAction: UIButton!
    @IBOutlet private weak var mailAction: UIButton!
    @IBOutlet private weak var stack: UIStackView!
    
    public init() {
        super.init(nibName: "ContactsView", bundle: Bundle.main)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        
        tabBarController?.navigationItem.title = "Контакты"
        
        descriptionText.textColor = UIColor.CustomColors.yellow
        descriptionText.font = getFontValue()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 5.0
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle]
        descriptionText.attributedText = NSAttributedString(string: Constants.contacts, attributes: attributes)
        
        configureMapView()
        configureActions()
        configureToast()
        
        stack.snp.remakeConstraints { make in
            let width = UIScreen.main.bounds.width - 64.0
            make.width.equalTo(width)
        }
    }
    
    private func configureMapView() {
        mapView.layer.masksToBounds = true
        mapView.layer.cornerRadius = 10.0
        mapView.layer.borderWidth = 1.0
        mapView.layer.borderColor = UIColor.CustomColors.yellow.cgColor
        
        mapView.delegate = self
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("город Кропивницький, улица Михайловская, 73") { (placemarks, error) in
            
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
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(openMapApp(recognizer:)))
        mapView.addGestureRecognizer(tapRecognizer)
    }
    
    private func configureActions() {
        webAction.addTarget(self, action: #selector(openUrl), for: .touchUpInside)
        phoneAction.addTarget(self, action: #selector(makeCall), for: .touchUpInside)
        mailAction.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
    }
    
    private func configureToast() {
        var style = ToastStyle()
        style.messageAlignment = .center
        style.activityBackgroundColor = .clear
        style.activityIndicatorColor = UIColor.CustomColors.yellow
        style.backgroundColor = UIColor.CustomColors.burgundy
        style.messageColor = UIColor.CustomColors.yellow
        style.messageAlignment = .center
        ToastManager.shared.style = style
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc private func openMapApp(recognizer: UITapGestureRecognizer) {
        let latitude: CLLocationDegrees = 48.504931
        let longitude: CLLocationDegrees = 32.269919
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let placemarkMap = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let mapItem = MKMapItem(placemark: placemarkMap)
        mapItem.name = "ХПП «Золотое шитье»"
        mapItem.openInMaps(launchOptions: options)
    }
    
    @objc private func openUrl() {
        if let url = URL(string: "http://www.zolotoe-shitvo.kr.ua") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc private func makeCall() {
        if let url = URL(string: "tel://+380505254567") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["info@zolotoe-shitvo.kr.ua"])
            mail.setSubject("Предварительный запрос")
            mail.setMessageBody("Добрый день! Интересует подробная информация ...\n\n\nОтправлено из приложения \"Золотое шитье\" v.2.1.0", isHTML: false)
            
            present(mail, animated: true)
        } else {
            showErrorToast("Проблемы с составлением письма, перейдите в почтовый клиент!")
        }
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
    
    private func showErrorToast(_ value: String) {
        self.view.makeToast(value, position: .center)
    }
}

extension ContactsView: MKMapViewDelegate {
    
}

extension ContactsView: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        var errorValue = ""
        switch result {
        case .cancelled:
            errorValue = "Отправка письма была отменена!"
            break
        case .saved:
            errorValue = "Письмо было сохранено!"
            break
        case .sent:
            errorValue = "Письмо было успешно отправлено!"
            break
        case .failed:
            errorValue = "Отправка письма закончилась неудачей!"
            break
        }
        
        if !errorValue.isEmpty {
            showErrorToast(errorValue)
        }
        
        controller.dismiss(animated: true)
    }
}
