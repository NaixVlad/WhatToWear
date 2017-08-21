//
//  CompasPoint.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 20.08.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import Foundation

enum CompassPoint: Float {
    
    case north = 0.0
    case northEast = 45.0
    case east = 90.0
    case southEast = 135.0
    case south = 180.0
    case southWest = 225.0
    case west = 270.0
    case northWest = 315.0
    
    var description: String {
        get {
            
            var string = ""
            
            switch self {
                
            case .north:
                string = "С"
            case .northEast:
                string = "С-В"
            case .east:
                string = "В"
            case .southEast:
                string = "Ю-В"
            case .south:
                string = "Ю"
            case .southWest:
                string = "Ю-З"
            case .west:
                string = "З"
            case .northWest:
                string = "С-З"
                
            }
            
            return string
            
        }
    }
    
    init(degrees: Float) {
        
        let range: Float = 27.5
        
        switch degrees {
        case CompassPoint.northEast.rawValue - range..<CompassPoint.northEast.rawValue + range:
            self = .northEast
        case CompassPoint.east.rawValue - range..<CompassPoint.east.rawValue + range:
            self = .east
        case CompassPoint.southEast.rawValue - range..<CompassPoint.southEast.rawValue + range:
            self = .southEast
        case CompassPoint.south.rawValue - range..<CompassPoint.south.rawValue + range:
            self = .south
        case CompassPoint.southWest.rawValue - range..<CompassPoint.southWest.rawValue + range:
            self = .southWest
        case CompassPoint.west.rawValue - range..<CompassPoint.west.rawValue + range:
            self = .west
        case CompassPoint.northWest.rawValue - range..<CompassPoint.northWest.rawValue + range:
            self = .northWest
        default:
            self = .north
            
        }
        
    }
    
}
