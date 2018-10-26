//
//  FirstVC.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 31.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import SystemConfiguration

class FirstVC: UIViewController {
    
    //MARK: - Properties -
    var start = Date()
    
    // MARK: - Outlets -
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.startAnimating()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // ask to preload all data by category
        if isFirstLaunch() {
            if isConnectedToNetwork() {
                getAllPosts()
                startOnboardingTutorial()
            } else {
                warningAlert()
            }
        } else {
            openCategoriesVC()
            isCategoryHasAllPosts()
            
        }
    }
    
    
    // MARK: - Navigation -
    func startOnboardingTutorial() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tutorialVC = storyboard.instantiateViewController(withIdentifier: "TutorialPageVC") as! TutorialPageVC
        self.present(tutorialVC, animated: true, completion: nil)
    }
    
    func openCategoriesVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
        self.present(tabbarVC, animated: false, completion: nil)
        
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let vC = storyboard.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
        //let nav = UINavigationController(rootViewController: vC)
        //UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
    }

    // MARK: - Private Methods -
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // check if app first launched
    func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
    
    // fetch all posts method
    func getAllPosts() {
        start = Date()
        PersistentService.getProductCategories { (prCat, count) in
            DispatchQueue.main.async {
                if prCat.count == count {
                    // 1
                    // get mitres ID = 6, posts 155
                    PersistentService.getServerAllPostsInCategory(6, withOffset: 0, callback: { (pro, postsCount) in
                        // set last updated category posts in ProductCategory entity
                        self.setLastUpdateProductCategory(categoryID: 6, maxPosts: postsCount)
                        if pro.count == 10 {
                            // 2
                            // get icons ID = 4, posts 144
                            PersistentService.getServerAllPostsInCategory(4, withOffset: 0, callback: { (pro, postsCount) in
                                // set last updated category posts in ProductCategory entity
                                self.setLastUpdateProductCategory(categoryID: 4, maxPosts: postsCount)
                                if pro.count == 10 {
                                    // 3
                                    // get metallonit ID = 101, posts 78
                                    PersistentService.getServerAllMetallonitPosts(withOffset: 0, callback: { (pro, postsCount) in
                                        // set last updated category posts in ProductCategory entity
                                        self.setLastUpdateProductCategory(categoryID: 101, maxPosts: postsCount)
                                        if pro.count == 10 {
                                            // 4
                                            // get komplekty dlia sborki mitr ID = 5, posts 49
                                            PersistentService.getServerAllPostsInCategory(5, withOffset: 0, callback: { (pro, postsCount) in
                                                // set last updated category posts in ProductCategory entity
                                                self.setLastUpdateProductCategory(categoryID: 5, maxPosts: postsCount)
                                            })
                                        }
                                    })
                                }
                            })
                        }
                    })
                    
                    
                    
                    // 5
                    // get oblacheniya iereiskie ID = 9, posts 28
                    PersistentService.getServerAllPostsInCategory(9, withOffset: 0, callback: { (pro, postsCount) in
                        // set last updated category posts in ProductCategory entity
                        self.setLastUpdateProductCategory(categoryID: 9, maxPosts: postsCount)
                        if pro.count == 10 {
                            // 6
                            // get oblacheniya archiereskie ID = 7, posts 27
                            PersistentService.getServerAllPostsInCategory(7, withOffset: 0, callback: { (pro, postsCount) in
                                // set last updated category posts in ProductCategory entity
                                self.setLastUpdateProductCategory(categoryID: 7, maxPosts: postsCount)
                                if pro.count == 10 {
                                    // 7
                                    // get skrizhali ID = 13, posts 21
                                    PersistentService.getServerAllPostsInCategory(13, withOffset: 0, callback: { (pro, postsCount) in
                                        // set last updated category posts in ProductCategory entity
                                        self.setLastUpdateProductCategory(categoryID: 13, maxPosts: postsCount)
                                        if pro.count == 10 {
                                            // 8
                                            // get pokrovcy ID = 11, posts 20
                                            PersistentService.getServerAllPostsInCategory(11, withOffset: 0, callback: { (pro, postsCount) in
                                                // set last updated category posts in ProductCategory entity
                                                self.setLastUpdateProductCategory(categoryID: 11, maxPosts: postsCount)
                                            })
                                        }
                                    })
                                }
                            })
                        }
                    })

                    // 9
                    // get tkani ID = 103, posts 15
                    PersistentService.getServerAllPostsTkani(withOffset: 0, callback: { (pro, postsCount) in
                        // set last updated category posts in ProductCategory entity
                        self.setLastUpdateProductCategory(categoryID: 103, maxPosts: postsCount)
                        if pro.count == 10 {
                            // 10
                            // get plaschanicy ID = 10, posts 14
                            PersistentService.getServerAllPostsInCategory(10, withOffset: 0, callback: { (pro, postsCount) in
                                // set last updated category posts in ProductCategory entity
                                self.setLastUpdateProductCategory(categoryID: 10, maxPosts: postsCount)
                                if pro.count == 10 {
                                    // 11
                                    // get oblachenie diakonskoe ID = 8, posts 14
                                    PersistentService.getServerAllPostsInCategory(8, withOffset: 0, callback: { (pro, postsCount) in
                                        // set last updated category posts in ProductCategory entity
                                        self.setLastUpdateProductCategory(categoryID: 8, maxPosts: postsCount)
                                        if pro.count == 10 {
                                            // 12
                                            // get ikonostasy ID = 3, posts 9
                                            PersistentService.getServerAllPostsInCategory(3, withOffset: 0, callback: { (pro, postsCount) in
                                                // set last updated category posts in ProductCategory entity
                                                self.setLastUpdateProductCategory(categoryID: 3, maxPosts: postsCount)
                                                if pro.count == 5 {
                                                    // 13
                                                    // get raznoe ID = 1, posts 47
                                                    PersistentService.getServerAllPostsFromPage(categoryID: 1, callback: { (pro, postsCount) in
                                                        // set last updated category posts in ProductCategory entity
                                                        self.setLastUpdateProductCategory(categoryID: 1, maxPosts: postsCount)
                                                    })
                                                    
                                                    // 14
                                                    // get geraldika
                                                    PersistentService.getServerAllPostsFromPage(categoryID: 18, callback: { (pro, postsCount) in
                                                        // set last updated category posts in ProductCategory entity
                                                        self.setLastUpdateProductCategory(categoryID: 18, maxPosts: postsCount)
                                                    })
                                                }
                                            })
                                        }
                                    })
                                }
                            })

                        }
                    })
                    
                    self.openCategoriesVC()
                }
                
            }
        }
    }
    
    // set last update for ProductCategory
    func setLastUpdateProductCategory(categoryID: Int, maxPosts: Int) {
        let moc = CoreDataStack.instance.persistentContainer.viewContext
        let products = Product.getProductsByParentCategory(productCatID: categoryID)
        if products.count == maxPosts {
            let end = Date().timeIntervalSince(start)
            print("get all posts from server in category \(categoryID) ready\n time elapsed \(end)")
            let category = ProductCategory.getPRCategoryBy(ID: categoryID, context: moc)
            category?.lastUpdate = Date() as NSDate
        }
    }
    
    // check even category is full
    func isCategoryHasAllPosts() {
        print("Log to fetch data if last time it wasn't\n**************************\n\n")

        PersistentService.getProductCategories { (categories, count) in
            for category in categories {
                let posts = Product.getProductsByParentCategory(productCatID: Int(category.id))
                print("there are \(posts.count) in category \(category.id)")
                // check if category doesn't has all posts or last update was more than 10 days ago
                let checkDate10DaysAgo = NSDate().addingTimeInterval(-10*24*60*60)
                if category.lastUpdate == nil {
                    category.lastUpdate = checkDate10DaysAgo
                }
                if Int(category.postsCount) > posts.count || category.lastUpdate! <= checkDate10DaysAgo {
                    if Int(category.id) == 101 {
                        PersistentService.getServerAllMetallonitPosts(withOffset: 0, callback: { (pro, postsCount) in
                            self.setLastUpdateProductCategory(categoryID: Int(category.id), maxPosts: postsCount)
                        })
                    } else if Int(category.id) == 103 {
                        PersistentService.getServerAllPostsTkani(withOffset: 0, callback: { (pro, postsCount) in
                            self.setLastUpdateProductCategory(categoryID: Int(category.id), maxPosts: postsCount)
                        })
                    } else if Int(category.id) == 1 {
                        PersistentService.getServerAllPostsFromPage(categoryID: Int(category.id), callback: { (pro, postsCount) in
                            self.setLastUpdateProductCategory(categoryID: Int(category.id), maxPosts: postsCount)
                        })
                    } else if Int(category.id) == 18 {
                        PersistentService.getServerAllPostsFromPage(categoryID: Int(category.id), callback: { (pro, postsCount) in
                            self.setLastUpdateProductCategory(categoryID: Int(category.id), maxPosts: postsCount)
                        })
                    } else {
                        PersistentService.getServerAllPostsFromPage(categoryID: Int(category.id), callback: { (pro, postsCount) in
                            self.setLastUpdateProductCategory(categoryID: Int(category.id), maxPosts: postsCount)
                        })
                    }
                }
            }
        }
    }
    
    // check internet connection
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
        
    }
    
    func warningAlert() {
        let alert = UIAlertController(title: "Ошибка доступности", message: "Отсутствует интернет-соединение или сервер временно недоступен! Мы с радостью предложим Вам каталог нашей продукции позже.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            action in
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        }))
            
        self.present(alert, animated: true, completion: nil)
    }
}
