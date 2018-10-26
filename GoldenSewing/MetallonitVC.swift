//
//  MetallonitVC.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 09.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class MetallonitVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    // MARK: - Outlets -
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var constr: NSLayoutConstraint!
    
    // MARK: - Properties -
    var productsArray = [Product]()
    var categoryID = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        // set naviagtion label
        switch categoryID {
        case 101:
            self.navigationItem.title = "Металлонить"
            textLabel.text = "Мы будем рады предложить Вам импортные нитки с металлизированной основой (метанит, металлонить) высокого качества. Мы предлагаем метанит, который идеально подходит для вышивки как машинным способом, так и металлонить и метанит различной толщины и цветовых оттенков для ручного шитья гладью, в прикреп и др. Способами. Применение цветной нити придает работе сочность и натурализм, сохраняя благородные свойства данного вида вышивки. Купить металлонить, на сегодняшний день, достаточно просто: интернет-магазин, рынок или любая сеть магазинов «все для шитья». Но качество всегда должно соответствовать цене, не только если Вы создаете промышленную вышивку, но и в случае, если для Вас это просто хобби. У нас Вы всегда сможете подобрать металлонить, которая подойдет как для вышивки элементов интерьера, одежды, картин, так и обрядовой продукции, в том числе, облачений священников\n\nЕсли Вас интересует более подробная информация по свойствам нитей, их применению или техники выполнения вышивки, Вы всегда можете написать нам или позвонить по телефонам, указанным в контактах."
        case 1:
            self.navigationItem.title = "Разное"
            textLabel.text = "В этой рубрике предлагаем вашему вниманию декоративные изделия для уюта Вашего дома: вышитые картины, открытки, панно и др, эксклюзивные подарки к праздникам как в ручном исполнении, так и в машинной вышивке ручной сборки. Возможно выполнение индивидуальных заказов по Вашему эскизу. По желанию заказчика возможна также и инкрустация канителью, натуральными камнями, стразами, бисером и др.  Если Вам нужна будет более подробная информация Вы всегда можете написать нам или позвонить по телефонам, указанным в контактах. С радостью ответим на любые Ваши вопросы."
        case 18:
            self.navigationItem.title = "Геральдика"
            textLabel.text = "У нас вы можете заказать геральдику любой степени сложности: гербы стран, городов, эмблемы служб и предприятий, вымпела, нашивки, погоны и мн.др., как в ручном исполнении, так и в машинной вышивке. По желанию заказчика возможна инкрустация канителью, натуральными камнями, стразами, бисером и др.  Если Вам нужна будет более подробная информация Вы всегда можете написать нам или позвонить по телефонам, указанным в контактах. С радостью ответим на любые Ваши вопросы."
        default:
            return
        }
        
        // set custom back button
        let customButton = UIBarButtonItem(image: UIImage(named: "back button"), style: .plain, target: self, action: #selector(backButtonTapped))
        customButton.tintColor = UIColor.CustomColors.yellow
        self.navigationItem.leftBarButtonItem = customButton
        
        // set custom back button2
        let customButton2 = UIBarButtonItem(image: UIImage(named: "back button"), style: .plain, target: self, action: nil)
        customButton2.tintColor = .clear
        self.navigationItem.rightBarButtonItem = customButton2
        
        collectionView.backgroundColor = UIColor.clear
        
        loadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if productsArray.isEmpty {
            showActivityIndicator()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - CollectionView -
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if categoryID == 101 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! CollViewCell
            cell.configureCell(productsArray[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath as IndexPath) as! RaznoeCell
            cell.configureCell(productsArray[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsAcross: CGFloat = 3
        let spaceBetweenCells: CGFloat = 10
        let dim = ((collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) - 32)/cellsAcross
        let dim2 = dim/1.44
        return categoryID == 101 ? CGSize(width: dim, height: dim2) : CGSize(width: dim, height: dim)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        vc.product = productsArray[indexPath.row]
        vc.modalPresentationStyle = .overCurrentContext
        //self.present(vc, animated: true, completion: nil)
        self.tabBarController?.present(vc, animated: true, completion: nil)
    }
    
    private func loadData() {
        productsArray = Product.getProductsByParentCategory(productCatID: categoryID)
        self.collectionView.reloadData()
    }
    
    func hideShowTabBar() {
        let boolValue = (tabBarController?.tabBar.isHidden)!
        tabBarController?.tabBar.isHidden = boolValue ? false : true
    }
    
    // MARK: - Navigation -
    @objc func backButtonTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private methods -
    func showActivityIndicator() {
        textLabel.isHidden = true
        let viewForActivityIndicator = UIView()
        let activityIndicatorView = UIActivityIndicatorView()
        let loadingTextLabel = UILabel()
        
        viewForActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        viewForActivityIndicator.backgroundColor = UIColor.clear
        view.addSubview(viewForActivityIndicator)
        
        activityIndicatorView.center = CGPoint(x: self.view.frame.size.width / 2.0, y: (self.view.frame.size.height - (self.tabBarController?.tabBar.frame.height)! - (self.navigationController?.navigationBar.frame.height)!) / 2.0)
        
        loadingTextLabel.textColor = UIColor.CustomColors.yellow
        loadingTextLabel.text = "\nИдет загрузка данных с сервера...\nЭто может занять какое-то время..."
        loadingTextLabel.textAlignment = .center
        loadingTextLabel.numberOfLines = 0
        loadingTextLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        loadingTextLabel.sizeToFit()
        loadingTextLabel.center = CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y + 30)
        viewForActivityIndicator.addSubview(loadingTextLabel)
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = UIColor.CustomColors.yellow
        viewForActivityIndicator.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }

}
