//
//  LocationServices.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 21.07.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

let kSelectedLocation = "selectedLocation"
let kIdOfSelectedLocation = "indexOfSelectedLocation"
let kTypeOfSelectedLocation = "typeOfSelectedLocation"

typealias JSONDictionary = [String:Any]
typealias SelectedLocation = (type: SelectedLocationType, location: Place)

enum SelectedLocationType: Int {
    case autodetection
    case manual
}

class LocationServices: NSObject {
    
    static let shared = LocationServices()
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    fileprivate override init() {
        super.init()
        self.locationManager.requestWhenInUseAuthorization()
        //locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
    }
    
    var currentLocation: CLLocation? {
        get {
            return locationManager.location
        }
    }
    
    var selectedLocation: SelectedLocation {
        get {
            
            let typeRawValue = UserDefaults.standard.integer(forKey: kTypeOfSelectedLocation)
            let type = SelectedLocationType(rawValue: typeRawValue)!
            
            
            switch type {
            case .autodetection:
                if CLLocationManager.locationServicesEnabled() {
                    return (type, locationManager.location!)
                }
            case .manual:
                if let urlString = UserDefaults.standard.string(forKey: kIdOfSelectedLocation) {
                    let manager = CoreDataManager.instance
                    let context = manager.managedObjectContext
                    let url = URL(string: urlString)
                    let id = manager.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url!)
                    let location = context.object(with: id!) as! Location
                    return (type, location)
                }
            }
            
            let defaultLocation = CLLocation(latitude: 53.798517, longitude: 99.185847)
            return (.manual, defaultLocation)
            
        }
        
        set {
            
            let (type, place) = newValue
            
            switch type {
            case .autodetection:
                UserDefaults.standard.set(type.rawValue, forKey: kTypeOfSelectedLocation)
            case .manual:
                let location = place as! Location
                let id = location.objectID.uriRepresentation().absoluteString
                UserDefaults.standard.set(type.rawValue, forKey: kTypeOfSelectedLocation)
                UserDefaults.standard.setValue(id, forKey: kIdOfSelectedLocation)
            }
        }
    }
    
    func getCurrentLocationAddress(completion: @escaping (_ address: JSONDictionary?, _ error: Error?) -> ()) {
        
        if CLLocationManager.locationServicesEnabled() {
            
            geocoder.reverseGeocodeLocation(self.currentLocation!) { placemarks, error in
                
                if let e = error {
                    
                    completion(nil, e)
                    
                } else {
                    
                    let placeArray = placemarks as? [CLPlacemark]
                    
                    var placeMark: CLPlacemark!
                    
                    placeMark = placeArray?[0]
                    
                    guard let address = placeMark.addressDictionary as? JSONDictionary else {
                        return
                    }
                    
                    completion(address, nil)
                    
                }
            }
        }
    }
}
/*

extension LocationServices: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        currentLocation = newLocation
        
        print("old location: \(oldLocation), new location: \(newLocation)")
        
    }
}*/
