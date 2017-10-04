//
//  DetailForecastView.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 03.10.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import UIKit

class DetailForecastView: UIView {

    @IBOutlet weak var scrollViewContainer: UIView!
    
    @IBOutlet weak var sunriseTimeValueLabel: UILabel!
    @IBOutlet weak var sunsetTimeValueLabel: UILabel!
    
    @IBOutlet weak var precipitationIntensityValueLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    
    @IBOutlet weak var windSpeedValueLabel: UILabel!
    @IBOutlet weak var windBearingValueLabel: UILabel!
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func createHourlyForecast(dates: [Date], weatherBlocks: [WeatherBlock],
                       temperatures: [Float], unitSize: CGFloat) {
    
            let width = self.frame.width
            let height = scrollViewContainer.frame.height
    
            let rect = CGRect(x: 0, y: 0, width: width, height: height)
            let scrollView = HourlyForecastScrollView(frame: rect,
                                                      dates: dates,
                                                      weatherBlocks: weatherBlocks,
                                                      temperatures: temperatures,
                                                      unitSize: unitSize)
    
            scrollView.showsHorizontalScrollIndicator = false
    
            scrollViewContainer.addSubview(scrollView)
    
        }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
