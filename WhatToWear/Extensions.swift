//
//  Extensions.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 23.07.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import Foundation
import ForecastIO
import SceneKit

extension CAAnimation {
    class func animationWithSceneNamed(_ name: String) -> CAAnimation? {
        var animation: CAAnimation?
        if let scene = SCNScene(named: name) {
            scene.rootNode.enumerateChildNodes({ (child, stop) in
                if child.animationKeys.count > 0 {
                    animation = child.animation(forKey: child.animationKeys.first!)
                    stop.initialize(to: true)
                }
            })
        }
        return animation
    }
}

extension Icon {
    func getImage() -> UIImage {
        
        let image = UIImage(named: self.rawValue)
        
        return image!
        
    }
    
    func getColor() -> UIColor {
        
        switch self {
        case .clearDay, .clearNight:
            return UIColor.сloudless
            
        case .partlyCloudyDay, .partlyCloudyNight, .wind:
            return UIColor.partlyCloudy
            
        case .cloudy, .fog:
            return UIColor.cloudy
            
        case .rain, .snow, .sleet:
            return UIColor.rain
            
        }
    }
}

extension Float {
    
    var percent: Int { get { return Int(self * 100) } }
    
}

extension String {
    
    func width(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

extension CGFloat {
    
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}



extension UIColor {
    
    public class var lightBackground: UIColor {
        return UIColor(red: 0.988, green: 0.988, blue: 0.988, alpha: 1.0)
    }
    
    public class var сloudless: UIColor {
        return UIColor(red: 0.933, green: 0.929, blue: 0.961, alpha: 1.0)
    }
    
    public class var partlyCloudy: UIColor {
        return UIColor(red: 0.831, green: 0.855, blue: 0.886, alpha: 1.0)
    }
    
    public class var cloudy: UIColor {
        return UIColor(red: 0.710, green: 0.750, blue: 0.800, alpha: 1.0)
    }
    
    public class var rain: UIColor {
        return UIColor(red: 0.478, green: 0.635, blue: 0.847, alpha: 1.0)
    }

    public class var refreshControlTintColor: UIColor {
        return UIColor(red:0.51, green:0.51, blue:0.51, alpha:1.0)
    }
    
    
    static var random: UIColor {
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
    }

}


extension UILabel {
    
    func setPrefferedTextColor() {
        
        if (self.backgroundColor?.isEqual(UIColor.rain))! {
            self.textColor = UIColor.white
        } else {
            self.textColor = UIColor.black
        }
        
    }
    
}



extension Date {
    
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
   
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    func format(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
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
    
    func getDataByDays() -> [[DataPoint]] {
        
        let dataPoints = self.data
        
        var days = [[DataPoint]]()
        
        var dayFlag = 0
        let midnight = "0:0"
        
        for i in 0..<dataPoints.count {
            
            let time = dataPoints[i].time.getTime()
            
            if (time == midnight && dayFlag != i) {
                
                let daySlice = dataPoints[dayFlag..<i+1]
                let dayDataPoints = Array(daySlice)
                /*let dayDates = dayDataPoint.map({ (dataPoint: DataPoint) -> Date in
                    dataPoint.time
                })*/
                days.append(dayDataPoints)
                dayFlag = i
                
            }
            
        }
        
        return days
        
    }
    
    func getDates() -> [[Date]] {
        
        let days = self.getDataByDays()
        
        var daysWithDates = [[Date]]()
        
        for day in days {
        
            let dayDates = day.map({ (dataPoint: DataPoint) -> Date in
                dataPoint.time
            })
            
           daysWithDates.append(dayDates)
            
        }
        
        return daysWithDates
        
    }
    
    func getTemperatures() -> [[Float]] {
        
        let days = self.getDataByDays()
        
        var daysWithTemperatures = [[Float]]()
        
        for day in days {
            
            let dayDates = day.map({ (dataPoint: DataPoint) -> Float in
                dataPoint.temperature!
            })
            
            daysWithTemperatures.append(dayDates)
            
        }
        
        return daysWithTemperatures
        
    }
    
    
    func getWeatherBlocks() -> [[WeatherBlock]] {
        
        
        var data = self.data
        
        let datesOfDays = self.getDates()
        
        var daysBlocks = [[WeatherBlock]]()
        
        
        for datesOfDay in datesOfDays {
            
            var dayBlocks = [WeatherBlock]()
            var i = 0
            
            for date in datesOfDay {
                
                if ((data[0].summary != data[i].summary) || (datesOfDay.last == date)) {

                    let weatherBlock = WeatherBlock()
                    weatherBlock.startTime = data[0].time
                    weatherBlock.endTime = data[i].time
                    
                    weatherBlock.description = data[0].summary!
                    weatherBlock.color = (data[0].icon?.getColor())!
                    
                    let slice = data.dropFirst(i)
                    let subArray = Array(slice)
                    data = subArray
                    dayBlocks.append(weatherBlock)
                    i = 0
                    
                }
                
                i += 1
                
            }
            
            daysBlocks.append(dayBlocks)
            
        }
        
        return daysBlocks
        
    }
}
