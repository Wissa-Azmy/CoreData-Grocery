//
//  ShoppingListDataProvider.swift
//  CoreData Grocery
//
//  Created by Wissa Azmy on 5/26/19.
//  Copyright © 2019 Wissa Azmy. All rights reserved.
//

import Foundation
import CoreData

protocol ShoppingListDataProviderDelegate {
    func dataDidChange(atIndex indexPath: IndexPath, changeType: ChangeType)
}

enum ChangeType {
    case delete, insert
}

class ShoppingListDataProvider: NSObject {
    var delegate: ShoppingListDataProviderDelegate!
    var managedObjectContext: NSManagedObjectContext!
    var fetchResultsController: NSFetchedResultsController<ShoppingList>!
    var sections: [NSFetchedResultsSectionInfo]? {
        return fetchResultsController.sections
    }
    
    init(managedObjectContext: NSManagedObjectContext) {
        super.init()
        self.managedObjectContext = managedObjectContext
        let request = NSFetchRequest<ShoppingList>(entityName: "ShoppingList")
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        try! fetchResultsController.performFetch()
        fetchResultsController.delegate = self
    }
    
    func object(at indexPath: IndexPath) -> ShoppingList {
        return fetchResultsController.object(at: indexPath)
    }
    
    func delete(shoppingList: ShoppingList) {
        managedObjectContext.delete(shoppingList)
        try! managedObjectContext.save()
    }

}


extension ShoppingListDataProvider: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            delegate.dataDidChange(atIndex: newIndexPath!, changeType: .insert)
        } else {
            delegate.dataDidChange(atIndex: indexPath!, changeType: .delete)
        }
        
    }
}
