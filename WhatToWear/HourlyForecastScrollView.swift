//
//  WeatherDescriptionScrollView.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 24.07.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import UIKit


class HourlyForecastScrollView: UIScrollView {
    
    var timeView: TimeView!
    var blockView: UIView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, data: [WeatherBlock], dates: [Date]) {
        super.init(frame: frame)
        
        createTimeLine(dates)
        arrangeWeatherData(data)
        
    }
    
    
    private func arrangeWeatherData(_ data: [WeatherBlock]) {
        
        
        let unit: CGFloat = 80
        var x = unit / 2
        let height = self.frame.height / 2
        for i in 0..<data.count {
            
            let block = data[i]
            print(block.color)
            print(block.duration)
            let rect = CGRect(x: x, y: 0, width: CGFloat(block.duration) * unit, height: height)
            let view = UIView(frame: rect)
            x = CGFloat(block.duration) * unit
            
            view.backgroundColor = block.color
            self.addSubview(view)
        }
        
    }
    
    private func createTimeLine(_ dates: [Date]) {
        
        let width: CGFloat = 80 * CGFloat(dates.count)
        let heigth: CGFloat = self.frame.height
        self.contentSize = CGSize(width: width, height: heigth)
        
        let y: CGFloat = heigth / 2
        let timeViewHeight = heigth / 2
        
        let rect = CGRect(x: 0, y: y, width: width, height: timeViewHeight)
        timeView = TimeView(frame: rect, dates: dates)
        
        self.addSubview(timeView)
        
    }
    

    
}
