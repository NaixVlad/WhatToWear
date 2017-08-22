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

typealias JSONDictionary = [String:Any]

class LocationServices {
    
    static let shared = LocationServices()
    
    private let locManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    var selectedLocation: CLLocation! {
        get {
            if let value = UserDefaults.standard.object(forKey: kSelectedLocation) as? CLLocation {
                return value
            } else {
                return CLLocation(latitude: 53.798517, longitude: 99.185847)
            }
        }
        
        set {
            
            //UserDefaults.standard.set()
            
        }
    }
    
    let authStatus = CLLocationManager.authorizationStatus()
    let inUse = CLAuthorizationStatus.authorizedWhenInUse
    let always = CLAuthorizationStatus.authorizedAlways
    
    func getAdressFromLocation(_ location: CLLocation, completion: @escaping (_ address: JSONDictionary?, _ error: Error?) -> ()) {
            
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                
                if let e = error {
                    
                    completion(nil, e)
                    
                } else {
                    
                    var placeMark: CLPlacemark!
                    
                    placeMark = placemarks?[0]
                    //print(placemarks)
                    guard let address = placeMark.addressDictionary as? JSONDictionary else {
                        return
                    }
                    
                    completion(address, nil)
                    
                }
                
            
        }
        
    }
    
    func getAdressFromCurentLocation() -> String {
        
        self.locManager.requestWhenInUseAuthorization()
        
        if self.authStatus == inUse || self.authStatus == always {
            
            return getAdressFromLocation(locManager.location!)
            
        } else {
            
            return ""
            
        }
        
    }
    
    func getAdressFromSelectedLocation() -> String {
        
        self.locManager.requestWhenInUseAuthorization()
        
        if self.authStatus == inUse || self.authStatus == always {
            
            return getAdressFromLocation(self.selectedLocation)
            
        } else {
            
            return ""
            
        }
        
    }
    
    func currentLocation() -> CLLocation {
        return locManager.location!
    }
    
    
    
    //MARK: - Helpers
        
    func getAdressFromLocation(_ location: CLLocation) -> String {
        
        var adress = "А"
        self.geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            print(placemarks)
            
            if let e = error {
                print("Reverse geocoder failed with error" + (e.localizedDescription))
                return
            }
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0] as! CLPlacemark
                adress = "\(pm.locality), \(pm.country)"
            } else {
                print("Problem with the data received from geocoder")
            }
        })
        
        return adress
    }
    
    
    fileprivate init() {
        self.locManager.requestWhenInUseAuthorization()
        locManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
}
