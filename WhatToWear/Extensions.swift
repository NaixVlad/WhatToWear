//
//  Extensions.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 23.07.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import Foundation
import ForecastIO

extension Icon {
    func getImage() -> UIImage {
        
        let image = UIImage(named: self.rawValue)
        
        return image!
        
    }
    
    func getColor() -> UIColor {
        
        switch self {
        case .clearDay, .clearNight:
            return UIColor.red
            
        /// A clear night.
        case .partlyCloudyDay, .partlyCloudyNight:
            return UIColor.lightGray
            
        case .cloudy, .fog:
            return UIColor.darkGray
            
        case .rain:
            return UIColor.blue
            
        /// A snowy day or night.
        case .snow:
            return UIColor.white
        /// A sleety day or night.
        case .sleet:
            return UIColor.white
        /// A windy day or night.
        case .wind:
            return UIColor.white


        }
    }
}

extension Date {
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }

    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    func getHour() -> String? {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour], from: self)
        let hour = comp.hour
        let strHour = "\(hour ?? 0)"
        return strHour
    }
    
    func getTime() -> String? {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: self)
        let hour = comp.hour
        let minute = comp.minute
        let strTime = "\(hour ?? 0):\(minute ?? 0)"
        return strTime
    }
    
}

extension DataBlock {
    
    func getDates() -> [[Date]] {
        
        let dataPoints = self.data
        
        var days = [[Date]]()
        
        var dayFlag = 0
        let midnight = "0:0"
        
        for i in 0..<dataPoints.count {
            
            let time = dataPoints[i].time.getTime()
            
            if (time == midnight) {
                
                let daySlice = dataPoints[dayFlag..<i+1]
                let dayDataPoint = Array(daySlice)
                let dayDates = dayDataPoint.map({ (dataPoint: DataPoint) -> Date in
                    dataPoint.time
                })
                days.append(dayDates)
                dayFlag = i
                
            }
            
        }
        
        return days
        
    }
    
    
    func getWeatherBlocks() -> [[WeatherBlock]] {
        
        
        var data = self.data
        
        let datesOfDays = self.getDates()
        
        var daysBlocks = [[WeatherBlock]]()
        
        
        for datesOfDay in datesOfDays {
            
            var dayBlocks = [WeatherBlock]()
            var i = 0
            
            for date in 0..<datesOfDay.count {
                i += 1
                print("Номер \(date)")
                if (data[date].icon != data[0].icon) || (date == datesOfDay.count-1){
                    
                    let weatherBlock = WeatherBlock()
                    weatherBlock.startTime = data[0].time
                    weatherBlock.description = data[0].summary!
                    
                    weatherBlock.endTime = data[date].time
                    print("Поменял:\(date)")
                    let slice = data.dropFirst(i-1)
                    let subArray = Array(slice)
                    data = subArray
                    dayBlocks.append(weatherBlock)
                    print("Осталось \(data.count)")
                    i = 0
                    
                }
                
            }
            
            daysBlocks.append(dayBlocks)
            
        }
        
        return daysBlocks
        
    }

    

    
    
}

