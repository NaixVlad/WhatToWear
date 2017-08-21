//
//  Measurements.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 21.08.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import Foundation


struct Temperature {
    var value = 0.0
    var measurement: TemperatureMeasurement
}
enum TemperatureMeasurement: String {
    case degreesCelsius = "°C"
    case degreesFahrenheit = "°F"
}


struct Speed {
    var value = 0.0
    var measurement: SpeedMeasurement
}
enum SpeedMeasurement: String {
    case metersPerHour = "м/с"  // 1 = 3,6 kilometersPerHour; 1 = 2,236936 milesPerHour;
    case kilometersPerHour = "км/ч" // 1 = 0,277778 metersPerHour; 1 = 0,621371 milesPerHour
    case milesPerHour = "миля/ч" // 1 = 0,44704 metersPerHour; 1 = 1,609344 kilometersPerHour;
}


struct Pressure {
    var value = 0.0
    var measurement: PressureMeasurement
}
enum PressureMeasurement: String {
    case millimetersOfMercury = "мм рт.ст."
    case hectopascals = "гПа" // 1 = 0.75006375541921 mmHg
}
