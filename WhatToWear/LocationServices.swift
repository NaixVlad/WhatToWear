//
//  LocationServices.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 21.07.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import Foundation
import CoreLocation

typealias JSONDictionary = [String:Any]

class LocationServices {
    
    static let shared = LocationServices()
    let locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    let authStatus = CLLocationManager.authorizationStatus()
    let inUse = CLAuthorizationStatus.authorizedWhenInUse
    let always = CLAuthorizationStatus.authorizedAlways
    
    func getAdress(completion: @escaping (_ address: JSONDictionary?, _ error: Error?) -> ()) {
        
        self.locManager.requestWhenInUseAuthorization()
        
        if self.authStatus == inUse || self.authStatus == always {
            
            self.currentLocation = locManager.location
            
            let geoCoder = CLGeocoder()
            
            geoCoder.reverseGeocodeLocation(self.currentLocation) { placemarks, error in
                
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
        
    }
    
    private init() {
        self.locManager.requestWhenInUseAuthorization()
        currentLocation = locManager.location
    }
    
}
