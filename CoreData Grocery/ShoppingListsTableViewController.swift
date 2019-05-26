//
//  ShoppingListsTableViewController.swift
//  CoreData Grocery
//
//  Created by Wissa Azmy on 5/23/19.
//  Copyright © 2019 Wissa Azmy. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListsTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var shoppingListDataSource: ShoppingListDataSource!
    var shoppingListDataProvider: ShoppingListDataProvider!
    var fetchResultsController: NSFetchedResultsController<ShoppingList>!

    override func viewDidLoad() {
        super.viewDidLoad()
        initDataProviderAndDataSource()
        tableView.dataSource = shoppingListDataSource
    }
    
    private func initDataProviderAndDataSource() {
        shoppingListDataProvider = ShoppingListDataProvider(managedObjectContext: managedObjectContext)
        shoppingListDataSource = ShoppingListDataSource(forCell: "Cell", ofTableView: tableView, withDataProvider: shoppingListDataProvider)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        headerView.backgroundColor = UIColor.lightText
        
        let addListTextField = UITextField(frame: headerView.frame)
        addListTextField.placeholder = "Enter Shopping List"
        addListTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        addListTextField.leftViewMode = .always
        addListTextField.delegate = self
        
        headerView.addSubview(addListTextField)
        
        return headerView
    }

}


// MARK: - TextField delegate
extension ShoppingListsTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let shoppingList = NSEntityDescription.insertNewObject(forEntityName: "ShoppingList", into: managedObjectContext) as! ShoppingList
        shoppingList.title = textField.text
        try! managedObjectContext.save()
        textField.text = ""
        
        return textField.resignFirstResponder()
    }
}
