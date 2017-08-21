//
//  WeatherDescriptionScrollView.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 24.07.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import UIKit


class HourlyForecastScrollView: UIScrollView {
    
    var timeView: UIView!
    var blocksView: UIView!
    var temperatureView: UIView!
    var unitSize: CGFloat = 0.0

    let paddingLeft: CGFloat = 36.0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init(frame: CGRect, dates: [Date], weatherBlocks: [WeatherBlock],
                  temperatures: [Float], unitSize: CGFloat) {
        super.init(frame: frame)
        
        self.unitSize = unitSize

        let width = unitSize * CGFloat(dates.count)
        self.contentSize = CGSize(width: width, height: frame.height)
        
        createTimePart(dates: dates)
        createWeatherDescriptionPart(weatherBlocks: weatherBlocks)
        createTemperaturePart(temperatures: temperatures)

    }
    
    
    private func createTimePart(dates: [Date]) {
        
        let height = self.contentSize.height / 3
        let width = self.contentSize.width
        
        let timeViewRect = CGRect(x: paddingLeft, y: 0, width: width, height: height)
        timeView = UIView(frame: timeViewRect)
        self.addSubview(timeView)
        
        let linesViewRect = CGRect(x: 0, y: height / 2, width: width, height: height / 2)
        let linesView = UIView(frame: linesViewRect)
        
        timeView.addSubview(linesView)
        createTimeLineInView(linesView)
        
        var i: CGFloat = 0
        for date in dates {
            let x: CGFloat = i * unitSize - unitSize / 2
            let labelRect = CGRect(x: x, y: 0, width: unitSize, height: height/2)
            let label = UILabel(frame: labelRect)
            
            if i == 0 {
                label.text = "Сейчас"
            } else {
                label.text = date.getHour()
            }
            
            label.textAlignment = .center
            
            label.font = UIFont (name: "HelveticaNeue-Light", size: 10)
            timeView.addSubview(label)
            i += 1
        }

        
    }
    
    
    
    private func createWeatherDescriptionPart(weatherBlocks: [WeatherBlock]) {
        
        
        let height = self.contentSize.height / 3
        let rect = CGRect(x: 0, y: height, width: self.contentSize.width, height: height)
        let blocksView = UIView(frame: rect)

        self.addSubview(blocksView)
        
        var x :CGFloat = paddingLeft
        for i in 0..<weatherBlocks.count {
            
            let block = weatherBlocks[i]
            let width = CGFloat(block.duration) * unitSize
            let rect = CGRect(x: x, y: 0, width: width, height: height)
            let label = UILabel(frame: rect)
            x += width
            
            label.backgroundColor = block.color
            
            let font = UIFont (name: "HelveticaNeue-Light", size: 14)
            let textWidth = block.description.width(usingFont: font!)
            
            if textWidth < width {
                
                label.textAlignment = .center
                label.font = font
                label.text = block.description
                
            }
            
            label.setPrefferedTextColor()
            
            label.layer.cornerRadius = 10
            label.layer.masksToBounds = true
            
            blocksView.addSubview(label)
            
            
        }

        
    }

    
    
    private func createTemperaturePart(temperatures: [Float]) {
        
        let height = self.contentSize.height / 3
        let width = self.contentSize.width
        
        let temperatureViewRect = CGRect(x: paddingLeft, y: height * 2, width: width, height: height)
        temperatureView = UIView(frame: temperatureViewRect)
        self.addSubview(temperatureView)
        
        let linesViewRect = CGRect(x: 0, y: 0, width: width, height: height / 2)
        let linesView = UIView(frame: linesViewRect)
        
        temperatureView.addSubview(linesView)
        createTimeLineInView(linesView)
        
        var i: CGFloat = 0
        for temperature in temperatures {
            let x: CGFloat = i * unitSize - unitSize / 2
            let labelRect = CGRect(x: x, y: height/2, width: unitSize, height: height/2)
            let label = UILabel(frame: labelRect)
            let intTemperature = Int(temperature)
            label.text = intTemperature.description + "°"
            label.textAlignment = .center
            label.font = UIFont (name: "HelveticaNeue-Light", size: 10)
            temperatureView.addSubview(label)
            i += 1
        }

        
        
    }
    
    
    // MARK: - Helpers
    
    private func createTimeLineInView(_ view: UIView) {
        
        let countOfLines = view.frame.width / unitSize
        let offset: CGFloat = 1.0
        
        for line in 0..<Int(countOfLines) {
            
            let x = CGFloat(line) * unitSize
            let lineHeight = view.frame.height - offset * 2
            let startPoint = CGPoint(x: x, y: 0 + offset)
            let endPoint = CGPoint(x: x, y: lineHeight)
            let layer = createLine(startPoint, endPoint: endPoint)
            view.layer.addSublayer(layer)
            
        }
        
    }
    
    private func createLine(_ startPoint: CGPoint, endPoint: CGPoint) -> CAShapeLayer {
        
        let path = UIBezierPath()
        
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.lineWidth = 1.0;
        
        return shapeLayer
    
    }
    
}

