//
//  ClientServices.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 23.07.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import Foundation
import ForecastIO

class ClientServices: DarkSkyClient {
    
    static let shared = ClientServices()
    
    //let client = DarkSkyClient(apiKey: "80699cc044c5a8677fbe48692fe0c850")
    
    private init() {
        
        super.init(apiKey: "80699cc044c5a8677fbe48692fe0c850")
        let lang = Locale.current.languageCode
        self.language = Language(rawValue: lang!)
        print(lang ?? "ENGLISH")
        self.units = .auto
        
    }
    
    /*func getDailyForecast(latitude: Double, longitude: Double) -> [DataPoint] {
        
        var tempArray = [DataPoint]()
        
        client.getForecast(latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let currentForecast, let requestMetadata):

                tempArray = (currentForecast.daily?.data)!
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }

        return tempArray
        
    }
    
    func getHorlyForecast(latitude: Double, longitude: Double) -> [DataPoint] {
        
        var tempArray = [DataPoint]()
        
        client.getForecast(latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let currentForecast, let requestMetadata):
                
                tempArray = (currentForecast.hourly?.data)!
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
        return tempArray
        
    }*/
    
    func redirectToDarkSky() {
        
        let url = URL(string: "https://darksky.net/poweredby/")
        if let reference = url {
            UIApplication.shared.open(reference, options: [:], completionHandler: nil)
        }
        
    }
    
}
