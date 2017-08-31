//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Vladislav Andreev on 23.08.17.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var timesSelected: Int64
    @NSManaged public var title: String?

}
