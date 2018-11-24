//
//  CategoriesView.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/23/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public class CategoriesView: UIViewController {
    
    // UI elements
    @IBOutlet private weak var categoriesTable: UITableView!
    
    private var presenter: CategoriesPresenter!
    
    public init() {
        super.init(nibName: "CategoriesView", bundle: Bundle.main)
        
        presenter = CategoriesPresenter(with: self)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        
        categoriesTable.dataSource = self
        categoriesTable.delegate = self
        
        CategoriesCell.register(in: categoriesTable)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.navigationItem.title = "Категории"
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        presenter.load()
    }

}

extension CategoriesView: CategoriesViewDelegate {
    public func reload() {
        categoriesTable.reloadData()
    }
    
    public func problemWithRequest() {
        #warning("Стас! Добавить показ сообщения с ошибкой")
    }
    
    public func showLoader() {
        #warning("Стас! Добавить показ загрузчика")
    }
    
    public func hideLoader() {
        #warning("Стас! Добавить скрытие загрузчика")
    }
}

extension CategoriesView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.countOfCategories()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = presenter.categoryAt(indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesCell.identifier) as! CategoriesCell
        cell.update(category: category)
        
        return cell
    }
}
extension CategoriesView: UITableViewDelegate { }
