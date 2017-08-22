//
//  Measurements.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 21.08.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import Foundation

enum TemperatureMeasurement: String {
    case degreesCelsius = "°C"
    case degreesFahrenheit = "°F"
}

struct Temperature {
    var value: Float = 0.0
    var measurement: TemperatureMeasurement = .degreesCelsius
    
    mutating func convertTo(_ measurement: TemperatureMeasurement) {
        if self.measurement != measurement {
            switch self.measurement {
            case .degreesCelsius:
                value = value * 1.8 + 32
            case .degreesFahrenheit:
                value = (value - 32) / 1.8
            }
            self.measurement = measurement
        }
    }
    
    init(value: Float) {
        self.value = value
        self.convertTo(Settings.shared.temperatureMeasurement)
    }
    
}




enum SpeedMeasurement: String {
    case metersPerHour = "м/с"  // 1 = 3,6 kilometersPerHour; 1 = 2,236936 milesPerHour;
    case kilometersPerHour = "км/ч" // 1 = 0,277778 metersPerHour; 1 = 0,621371 milesPerHour
    case milesPerHour = "миля/ч" // 1 = 0,44704 metersPerHour; 1 = 1,609344 kilometersPerHour;
}

struct Speed {
    var value: Float = 0.0
    var measurement: SpeedMeasurement = .metersPerHour {
        
        didSet {
            self.convertTo(measurement)
        }
    }
    
    mutating func convertTo(_ measurement: SpeedMeasurement) {
        
        if self.measurement != measurement {
            switch self.measurement {
            case .metersPerHour where (measurement == .kilometersPerHour):
                value *= 3.6
            case .metersPerHour where (measurement == .milesPerHour):
                value *= 2.236936
            case .kilometersPerHour where (measurement == .metersPerHour):
                value *= 0.277778
            case .kilometersPerHour where (measurement == .milesPerHour):
                value *= 0.621371
            case .milesPerHour where (measurement == .metersPerHour):
                value *= 0.44704
            case .milesPerHour where (measurement == .kilometersPerHour):
                value *= 1.609344
            default: break
            }
            self.measurement = measurement
        }
    }
    
    init(value: Float) {
        self.value = value
        self.convertTo(Settings.shared.speedMeasurement)
    }
}




enum PressureMeasurement: String {
    case millimetersOfMercury = "мм рт.ст." // 1 = 1.33322
    case hectopascals = "гПа" // 1 = 0.75006375541921 mmHg
}

struct Pressure {
    var value: Float = 0.0
    var measurement: PressureMeasurement = .millimetersOfMercury {
     
        didSet {
            self.convertTo(measurement)
        }
        
    }

    mutating func convertTo(_ measurement: PressureMeasurement) {
    
        if self.measurement != measurement {
            switch self.measurement {
            case .millimetersOfMercury:
                value *= 1.33322
            case .hectopascals:
                value *= 0.75006375541921
            }
            self.measurement = measurement
        }
    }
    
    init(value: Float) {
        self.value = value
        self.convertTo(Settings.shared.pressureMeasurement)
    }
}
