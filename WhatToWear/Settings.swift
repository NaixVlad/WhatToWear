//
//  Settings.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 21.08.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import Foundation

let kTemperatureMeasurement = "temperatureMeasurement"
let kSpeedMeasurement = "speedMeasurement"
let kPressureMeasurement = "pressureMeasurement"
let kSex = "sex"

enum Sex: Int {
    case male
    case female
}


class Settings {
    
    static let shared = Settings()
    
    fileprivate init() {
        
    }
    
    var temperatureMeasurement: TemperatureMeasurement {
        get {
            
            if let value = UserDefaults.standard.string(forKey: kTemperatureMeasurement) {
                return TemperatureMeasurement(rawValue: value)!
            } else {
                return TemperatureMeasurement.degreesCelsius
            }
            
        }
        
        set {
        
            UserDefaults.standard.set(newValue.rawValue, forKey: kTemperatureMeasurement)
            
        }
    }

    
    var speedMeasurement: SpeedMeasurement {
        get {
            if let value = UserDefaults.standard.string(forKey: kSpeedMeasurement) {
                return SpeedMeasurement(rawValue: value)!
            } else {
                return SpeedMeasurement.metersPerHour
            }
        }
        
        set {
            
            UserDefaults.standard.set(newValue.rawValue, forKey: kSpeedMeasurement)
            
        }
    }
    
    var pressureMeasurement: PressureMeasurement {
        get {
            if let value = UserDefaults.standard.string(forKey: kPressureMeasurement) {
                return PressureMeasurement(rawValue: value)!
            } else {
                return PressureMeasurement.millimetersOfMercury
            }
        }
        
        set {
            
            UserDefaults.standard.set(newValue.rawValue, forKey: kPressureMeasurement)
            
        }
    }

    var characterSex: Sex {
        get {
            let value = UserDefaults.standard.integer(forKey: kSex)
            return Sex(rawValue: value) ?? .male
        }
        
        set {
            
            UserDefaults.standard.setValue(newValue.rawValue, forKey: kSex)
            
        }
    }
    
    
    

    
}
