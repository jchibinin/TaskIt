//
//  TaskModel.swift
//  TaskIt2
//
//  Created by Yakov on 10/11/15.
//  Copyright © 2015 Bitfoundation. All rights reserved.
//

import Foundation
import CoreData

class TaskModel: NSManagedObject {
    
    @NSManaged var date:  NSDate?
    @NSManaged var task:  String?
    @NSManaged var order: Int32
    @NSManaged var schedule: String?
    
    func lastMaxPosition () -> Int32 {
        let predicate = NSPredicate(format: "schedule == %@", "")
        let request = NSFetchRequest(entityName: self.entity.name!)
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: false)]
        request.predicate = predicate
        
        let context : NSManagedObjectContext = self.managedObjectContext!
        do {
            let todos = try context.executeFetchRequest(request) as! [TaskModel]
            
            return todos.isEmpty ? 0 : todos[0].order
            
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
            
       return 0
    }
}
