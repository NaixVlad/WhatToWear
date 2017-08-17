//
//  WeatherBlock.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 24.07.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import Foundation
import ForecastIO


class WeatherBlock {

    var startTime: Date!
    var endTime: Date!
    
    var duration: Int {
        return Int(endTime.getHour()!)! - Int(startTime.getHour()!)!
    }
    
    
    var description = "Ясно"
    
    var color = UIColor.white
    
    
}
