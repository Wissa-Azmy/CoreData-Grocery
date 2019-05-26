//
//  ShoppingListDataSource.swift
//  CoreData Grocery
//
//  Created by Wissa Azmy on 5/26/19.
//  Copyright © 2019 Wissa Azmy. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListDataSource: NSObject, UITableViewDataSource {
    var tableView: UITableView!
    var cellIdentifier: String!
    var shoppingListDataProvider: ShoppingListDataProvider!
    
    init(forCell cellIdentifier: String, ofTableView tableView: UITableView, withDataProvider shoppingListDataProvider: ShoppingListDataProvider) {
        super.init()
        self.tableView = tableView
        self.cellIdentifier = cellIdentifier
        self.shoppingListDataProvider = shoppingListDataProvider
        self.shoppingListDataProvider.delegate = self
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if let sections = shoppingListDataProvider.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let sections = shoppingListDataProvider.sections {
            return sections[section].numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let shoppingList = shoppingListDataProvider.object(at: indexPath)
        cell.textLabel?.text = shoppingList.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let shoppingList = shoppingListDataProvider.object(at: indexPath)
        
        if editingStyle == .delete {
            shoppingListDataProvider.delete(shoppingList: shoppingList)
        }
        
        tableView.isEditing = false
    }
}

extension ShoppingListDataSource: ShoppingListDataProviderDelegate {
    func dataDidChange(atIndex indexPath: IndexPath, changeType: ChangeType) {
        if changeType == .insert {
            tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
