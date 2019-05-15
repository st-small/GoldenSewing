//
//  TutorialPageVC.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 03.09.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class TutorialPageVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    public var onCompleteHandler: Trigger?
    
    private var properties = UserDefaults.standard
    
    fileprivate let contentImages = [("Onboard_1", "Мы рады приветствовать Вас в нашем приложении. Предлагаем ознакомиться с основными возможностями!"),
                                     ("Onboard_2", "Экран «Категории» предлагает Вам выбор разделов с нашей продукцией. Выбирайте интересующий раздел."),
                                     ("Onboard_3", "Используйте «Поиск» для удобного и быстрого отображения, интересующих Вас изделий."),
                                     ("Onboard_4", "Используйте «Поиск» в выбранной категории, используя название или номер артикула."),
                                     ("Onboard_5", "Выберите заинтересовавшее Вас изделие для подробного просмотра описания."),
                                     ("Onboard_6", "Для перехода в «Подробный просмотр» нажмите на фотографию."),
                                     ("Onboard_7", "Для возврата к списку изделий, нажмите на любое из полей описания, чтобы свернуть просмотр."),
                                     ("Onboard_8", "Увеличивайте или уменьшайте фотографию для удобного просмотра. Ставьте оценку от 1 до 5 изделиям, которые понравились."),
                                     ("Onboard_9", "Закажите подробную информацию по данному изделию, свяжитесь с нами, нажав кнопку «Заказать» или нажмите на поле вне фотографии для выхода к списку изделий."),
                                     ("Onboard_10", "Вкладка «Контакты» поможет Вам связаться с нами или проложить правильный маршрут для посещения выставки изделий."),
                                     ("Onboard_11", "Вкладка «Избранное» отображает изделия с оценкой, а также историю просмотренных Вами изделий."),
                                     ("Onboard_12", "Для повторного просмотра данного «Руководства», следует нажать значок «info» в разделе «Категории»."),
                                     ("Onboard_1", "В добрый путь! Приятного просмотра!")]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        if contentImages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers = [firstController]
            self.setViewControllers(startingViewControllers, direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        }
        
        setupPageControl()
    
        properties.set(true, forKey: "onboardingIsShown")
    }
    
    fileprivate func setupPageControl() {
        self.view.backgroundColor = UIColor.CustomColors.burgundy
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.CustomColors.lightYellow
        appearance.currentPageIndicatorTintColor = UIColor.CustomColors.yellow
        appearance.backgroundColor = UIColor.CustomColors.burgundy
    }
    
    // MARK: - UIPageViewControllerDataSource methods -
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemVC
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex - 1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! PageItemVC
        
        if itemController.itemIndex + 1 < contentImages.count {
            return getItemController(itemController.itemIndex + 1)
        }
        
        if itemController.itemIndex == contentImages.count - 1 {
            UIView.animate(withDuration: 3.0, animations: {
                self.onCompleteHandler?()
            })
        }
        
        return nil
    }
    
    fileprivate func getItemController(_ itemIndex: Int) -> PageItemVC? {
        
        if itemIndex < contentImages.count {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pageItemVC = storyboard.instantiateViewController(withIdentifier: "PageItemVC") as! PageItemVC
            pageItemVC.itemIndex = itemIndex
            pageItemVC.contentModel = contentImages[itemIndex]
            pageItemVC.delegate = self
            return pageItemVC
        }
        
        return nil
    }
    
    // MARK: - Page Indicator -
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return contentImages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // MARK: - Additions
    func currentControllerIndex() -> Int {
        
        let pageItemController = self.currentController()
        
        if let controller = pageItemController as? PageItemVC {
            return controller.itemIndex
        }
        
        return -1
    }
    
    func currentController() -> UIViewController? {
        
        if (self.viewControllers?.count)! > 0 {
            return self.viewControllers![0]
        }
        
        return nil
    }

}

extension TutorialPageVC: LaunchControllerDelegate {
    
    var notNeedDisplay: Bool {
        return false
        //return properties.bool(forKey: "onboardingIsShown")
    }
    
    func hiddenProcessing() { }
}


extension TutorialPageVC: PageItemVCDelegate {
    public func skipTutorial() {
        onCompleteHandler?()
    }
}
