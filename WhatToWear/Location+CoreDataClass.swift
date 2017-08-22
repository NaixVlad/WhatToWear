//
//  Location+CoreDataClass.swift
//  
//
//  Created by Vladislav Andreev on 22.08.17.
//
//

import Foundation
import CoreData


public class Location: NSManagedObject {
    
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName("Location"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
    
}
