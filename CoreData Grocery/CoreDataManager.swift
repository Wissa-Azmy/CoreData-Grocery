//
//  CoreDataManager.swift
//  CoreData Grocery
//
//  Created by Wissa Azmy on 5/26/19.
//  Copyright © 2019 Wissa Azmy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    var managedObjectContext: NSManagedObjectContext!
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator!
    private var managedObjectModel: NSManagedObjectModel!
    
    func initializeCoreDataStack() {
        initManagedObjectModel()
        createDataStore()
        configManagedObjectContext()
    }
    
    private func initManagedObjectModel() {
        // Get the managedObjectModel file
        guard let modelURL = Bundle.main.url(forResource: "MyGroceryDataModel", withExtension: "momd") else {
            fatalError("Unable to initialize ManagedObjectModel")
        }
        
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to initialize a ManagedObjectModel")
        }
        
        self.managedObjectModel = model
    }
    
    private func createDataStore() {
        // Create the store coordinator
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        // Create a data store path
        guard let documentsURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to get documets URL")
        }
        
        let storeURL = documentsURL.appendingPathComponent("MyGrocery.sqlite")
        
        print(storeURL)
        
        // Add the data store at the created path
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
    }
    
    private func configManagedObjectContext() {
        let type = NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: type)
        self.managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    }
}
