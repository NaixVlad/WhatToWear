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
let kUrlOfSelectedLocation = "indexOfSelectedLocation"
let kTypeOfSelectedLocation = "typeOfSelectedLocation"

typealias JSONDictionary = [String:Any]
typealias SelectedLocation = (type: SelectedLocationType, location: Place?)

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
        self.selectedLocation.type = .manual
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()

    }
    
    var selectedLocation: SelectedLocation {
        get {
            
            let typeRawValue = UserDefaults.standard.integer(forKey: kTypeOfSelectedLocation)
            
            if let type = SelectedLocationType(rawValue: typeRawValue) {
                
            
            
                switch type {
                case .autodetection:
                    
                    return (type, locationManager.location)
                    
                case .manual:
                    if let urlString = UserDefaults.standard.string(forKey: kUrlOfSelectedLocation) {
                        let manager = CoreDataManager.instance
                        let context = manager.managedObjectContext
                        let url = URL(string: urlString)
                        let urlString = manager.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url!)
                        let location = context.object(with: urlString!) as! Location
                        return (type, location)
                    }
                }
            }
            
            let defaultType = SelectedLocationType.manual
            let defaultLocation = getDefaultLocation()
            
            let urlString = defaultLocation.objectID.uriRepresentation().absoluteString
            UserDefaults.standard.set(defaultType.rawValue, forKey: kTypeOfSelectedLocation)
            UserDefaults.standard.setValue(urlString, forKey: kUrlOfSelectedLocation)
            
            return (defaultType, defaultLocation)
            
        }
        
        set {
            
            let (type, place) = newValue
            
            switch type {
            case .autodetection:
                UserDefaults.standard.set(type.rawValue, forKey: kTypeOfSelectedLocation)
            case .manual:
                let location = place as? Location ?? getDefaultLocation()
                let urlString = location.objectID.uriRepresentation().absoluteString
                UserDefaults.standard.set(type.rawValue, forKey: kTypeOfSelectedLocation)
                UserDefaults.standard.setValue(urlString, forKey: kUrlOfSelectedLocation)
                    
            }
        }
    }
    
    func getCurrentLocationAddress(completion: @escaping (_ address: JSONDictionary?, _ error: Error?) -> ()) {
        
        if CLLocationManager.locationServicesEnabled(), let loc = locationManager.location  {
            
            geocoder.reverseGeocodeLocation(loc) { placemarks, error in
                
                if let e = error {
                    
                    completion(nil, e)
                    
                } else {
                    
                    let placeArray = placemarks
                    
                    var placeMark: CLPlacemark!
                    
                    placeMark = placeArray?[0]
                    
                    guard let address = placeMark.addressDictionary as? JSONDictionary else {
                        return
                    }
                    
                    completion(address, nil)
                    
                }
            }
            
        } else {
            completion(nil, nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
            self.selectedLocation.type = .autodetection
            
        }
    }
    
    func getDefaultLocation() -> Location {

        let defaultLocation = Location()
        defaultLocation.latitude = 53.798517
        defaultLocation.longitude = 99.185847
        defaultLocation.timesSelected = 1
        defaultLocation.title = "Москва"
        CoreDataManager.instance.saveContext()
        
        return defaultLocation
    }
}
