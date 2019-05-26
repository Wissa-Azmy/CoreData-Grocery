//
//  ShoppingListsTableViewController.swift
//  CoreData Grocery
//
//  Created by Wissa Azmy on 5/23/19.
//  Copyright © 2019 Wissa Azmy. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListsTableViewController: UITableViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    var shoppingListDataProvider: ShoppingListDataProvider!
    var managedObjectContext: NSManagedObjectContext!
    var fetchResultsController: NSFetchedResultsController<ShoppingList>!

    override func viewDidLoad() {
        super.viewDidLoad()
        initDataProviderAndDataSource()
    }
    
    private func initDataProviderAndDataSource() {
        shoppingListDataProvider = ShoppingListDataProvider(managedObjectContext: managedObjectContext)
    }
    
    
    // MARK: - TextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let shoppingList = NSEntityDescription.insertNewObject(forEntityName: "ShoppingList", into: managedObjectContext) as! ShoppingList
        shoppingList.title = textField.text
        try! managedObjectContext.save()
        textField.text = ""
        
        return textField.resignFirstResponder()
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
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if let sections = fetchResultsController.sections {
            return sections.count
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let sections = fetchResultsController.sections {
            return sections[section].numberOfObjects
        }
        
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let shoppingList = fetchResultsController.object(at: indexPath)
        cell.textLabel?.text = shoppingList.title
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let shoppingList = fetchResultsController.object(at: indexPath)
        
        if editingStyle == .delete {
            managedObjectContext.delete(shoppingList)
            try! managedObjectContext.save()
        }
        
        tableView.isEditing = false
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
