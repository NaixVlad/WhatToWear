//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Vladislav Andreev on 22.08.17.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var timesSelected: Int64

}
