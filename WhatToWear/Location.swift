//
//  Location.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 23.08.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation


protocol Place {
    var latitude: Double { get }
    var longitude: Double { get }

}

extension CLLocation: Place {
    
    var latitude: Double { get { return self.coordinate.latitude} }
    var longitude: Double { get { return self.coordinate.longitude} }
    
}

public class Location: NSManagedObject, Place {
    
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName("Location"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
    
}
