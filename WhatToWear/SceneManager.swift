//
//  SceneManager.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 03.10.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import Foundation
import SceneKit
import ForecastIO

enum Skybox {
    case clearDay
    case clearNight
    case partlyCloudyDay
    case partlyCloudyNight
    case cloudyDay
    case cloudyNight
    
    func getArrayOfImages() -> [String] {
        switch self {
        case .clearDay:
            return ["art.scnassets/skyboxes/ClearDayRight.png",
                    "art.scnassets/skyboxes/ClearDayLeft.png",
                    "art.scnassets/skyboxes/ClearDayTop.png",
                    "art.scnassets/skyboxes/ClearDayBottom.png",
                    "art.scnassets/skyboxes/ClearDayBack.png",
                    "art.scnassets/skyboxes/ClearDayFront.png"]
        case .clearNight:
            return ["art.scnassets/skyboxes/ClearNightRight.png",
                    "art.scnassets/skyboxes/ClearNightLeft.png",
                    "art.scnassets/skyboxes/ClearNightTop.png",
                    "art.scnassets/skyboxes/ClearNightBottom.png",
                    "art.scnassets/skyboxes/ClearNightBack.png",
                    "art.scnassets/skyboxes/ClearNightFront.png"]
            
        case .partlyCloudyDay:
            return ["art.scnassets/skyboxes/PartlyCloudyDayRight.png",
                    "art.scnassets/skyboxes/PartlyCloudyDayLeft.png",
                    "art.scnassets/skyboxes/PartlyCloudyDayTop.png",
                    "art.scnassets/skyboxes/PartlyCloudyDayBottom.png",
                    "art.scnassets/skyboxes/PartlyCloudyDayBack.png",
                    "art.scnassets/skyboxes/PartlyCloudyDayFront.png"]
        case .partlyCloudyNight:
            return ["art.scnassets/skyboxes/PartlyCloudyNightRight.png",
                    "art.scnassets/skyboxes/PartlyCloudyNightLeft.png",
                    "art.scnassets/skyboxes/PartlyCloudyNightTop.png",
                    "art.scnassets/skyboxes/PartlyCloudyNightBottom.png",
                    "art.scnassets/skyboxes/PartlyCloudyNightBack.png",
                    "art.scnassets/skyboxes/PartlyCloudyNightFront.png"]
        case .cloudyDay:
            return ["art.scnassets/skyboxes/CloudyDayRight.jpg",
                    "art.scnassets/skyboxes/CloudyDayLeft.jpg",
                    "art.scnassets/skyboxes/CloudyDayTop.jpg",
                    "art.scnassets/skyboxes/CloudyDayBottom.jpg",
                    "art.scnassets/skyboxes/CloudyDayBack.jpg",
                    "art.scnassets/skyboxes/CloudyDayFront.jpg"]
        case .cloudyNight:
            return ["art.scnassets/skyboxes/CloudyNightRight.png",
                    "art.scnassets/skyboxes/CloudyNightLeft.png",
                    "art.scnassets/skyboxes/CloudyNightTop.png",
                    "art.scnassets/skyboxes/CloudyNightBottom.png",
                    "art.scnassets/skyboxes/CloudyNightBack.png",
                    "art.scnassets/skyboxes/CloudyNightFront.png"]
        }
    }
}

enum TimeOfDay {
    case day
    case night
}

class SceneManager {
    
    static let shared = SceneManager()
    let scene = SCNScene(named: "art.scnassets/Scene.scn")!
    var character: Character?
    let lampLeft: SCNLight!
    let lampRight: SCNLight!
    let sun: SCNLight!
    fileprivate init() {
        
        let lampPostLeft = scene.rootNode.childNode(withName: "lampLeft", recursively: true)!
        lampLeft = lampPostLeft.light
       
        let lampPostRight = scene.rootNode.childNode(withName: "lampRight", recursively: true)!
        lampRight = lampPostRight.light
        
        let sunNode = scene.rootNode.childNode(withName: "sun", recursively: true)!
        sun = sunNode.light

    }
    
    func setupSceneWithDayData(_ dayData: DataPoint, hourData: DataPoint)  {
        
        let timeOfDay = timeOfDaySunrise(dayData.sunriseTime!, sunset: dayData.sunsetTime!)
        
        setupLightingForTimeOfDay(timeOfDay)
        
        var isFoggy = false
        
        
        switch hourData.icon! {
        case .clearDay, .clearNight:
            if timeOfDay == .day {
                scene.background.contents = Skybox.clearDay.getArrayOfImages()
            } else {
                scene.background.contents = Skybox.clearNight.getArrayOfImages()
            }
           
        case .partlyCloudyDay, .partlyCloudyNight, .wind:
            if timeOfDay == .day {
                scene.background.contents = Skybox.partlyCloudyDay.getArrayOfImages()
            } else {
                scene.background.contents = Skybox.partlyCloudyNight.getArrayOfImages()
            }

        case .fog:
            
            isFoggy = true
            
            fallthrough
            
        case .rain, .sleet, .snow, .cloudy:
            if timeOfDay == .day {
                scene.background.contents = Skybox.cloudyDay.getArrayOfImages()
            } else {
                scene.background.contents = Skybox.cloudyNight.getArrayOfImages()
            }
            
            
            
        }
        
        if isFoggy {
            scene.fogStartDistance = 1000
            scene.fogEndDistance = 2000
        } else {
            scene.fogStartDistance = 0
            scene.fogEndDistance = 0
        }
        
    }
        
    func setupCharacter(_ data: DataPoint)  {
        
        let sex = Settings.shared.characterSex
        let temperature = Temperature(value: data.apparentTemperature!)
        let tempCharacter = Character(sex: sex, temperature: temperature)
        
        if character == nil {
            
            scene.rootNode.addChildNode(tempCharacter.node)
            tempCharacter.idle()
            
        }
            
            character = tempCharacter

    }
    
    func setupLightingForTimeOfDay(_ timeOfDay: TimeOfDay) {
        
        switch timeOfDay {
        case .day:
            sun.intensity = 1000
            lampLeft.intensity = 0
            lampRight.intensity = 0
        case .night:
            sun.intensity = 100
            lampLeft.intensity = 500
            lampRight.intensity = 500
        }
    }
    
    
    //MARK: Helpers
    
    func timeOfDaySunrise(_ sunrise: Date, sunset: Date) -> TimeOfDay {
        
        let currentDate = Date()
        
        if sunrise.minutes(from: currentDate) >= 0 || currentDate.minutes(from: sunset) >= 0 {
            return .night
        } else {
            return .day
        }
        
    }
    
}






