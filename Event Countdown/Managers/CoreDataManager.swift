//
//  CoreDataManager.swift
//  Event Countdown
//
//  Created by Darragh Blake on 10/02/2020.
//  Copyright © 2020 Darragh Blake. All rights reserved.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EventModel")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    func fetchEvents() -> [Event] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        
        do {
            let events = try context.fetch(fetchRequest)
            return events
        } catch let fetchErr {
            print("Failed to fetch events:", fetchErr)
            return []
        }
    }
}
