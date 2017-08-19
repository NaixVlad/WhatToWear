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
        return endTime.hours(from: startTime)
    }
    
    
    var description = ""
    
    var color = UIColor.white
    

    
}
