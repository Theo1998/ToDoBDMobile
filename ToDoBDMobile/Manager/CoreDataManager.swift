//
//  CoreDataManager.swift
//  ToDoBDMobile
//
//  Created by lpiem on 18/03/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    // MARK: - Propriétés
    static let shared = CoreDataManager()
    var delegate: DataManagerDelegate?
    var items: [Tache] = []
    
    // MARK: - Initialisation
    private init(){
      //  items = self.loadItems()
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Todo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // let newItem = Item(context: self.dataManager.context)
    //
}

extension CoreDataManager {
    
    func addItem(_ item: Tache) {
        print("data manager - addItem - tache : \(item)")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.items.append(item)
        delegate?.didAddItem(item)
        print("data manager - taches list : \(self.items)")
        self.saveData()
    }    
    
    func removeItem(_ item: Tache) {
        context.delete(item)        
    }
    
    func loadItems(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tache")
        do {
            items = try context.fetch(fetchRequest) as! [Tache]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveData(){
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

protocol DataManagerDelegate : class {
    func didAddItem(_ item: Tache)
    func didUpdateItem(_ item: Tache)
    func didDeleteItem(_ item: Tache)
    func didDidLoadItem(_ item: Tache)
}
