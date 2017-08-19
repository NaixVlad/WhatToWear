//
//  TimeLineViewWithLabels.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 24.07.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import UIKit

class TimeView: UIView {

/*
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    init(frame: CGRect, dates: [Date], padding: CGFloat = 0) {
        super.init(frame: frame)
        
        let count = dates.count
        
        let width = frame.size.width
        let height = frame.size.height
        
        let dualPadding = padding * 2
        let usefulWidth = width - CGFloat(dualPadding)
        let divider = usefulWidth / CGFloat(count)
        
        let lineHeight = height / 2
        let labelHeigth = lineHeight
        let labelWidth = width / CGFloat(count)
        let offset: CGFloat = 2
        
        for i in 0..<count {
            
            let x = divider * CGFloat(i) + padding + divider/2
            let startPoint = CGPoint(x: x, y: 0 + offset)
            let endPoint = CGPoint(x: x, y: lineHeight)
            let layer = createLine(startPoint, endPoint: endPoint)
            self.layer.addSublayer(layer)
            
            let labelX = labelWidth * CGFloat(i)
            let labelY = height / 2 - offset
            let labelRect = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeigth)
            let dateLabel = createDateLabel(dates[i], frame: labelRect)
            let temperatureLabel = createTemperatureLabel(0, frame: labelRect)
            self.addSubview(dateLabel)
            self.addSubview(temperatureLabel)
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
    
    private func createDateLabel(_ date: Date, frame: CGRect) -> UILabel {
        
        let label = UILabel(frame: frame)
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = date.getTime()!
        
        return label
        
        
    }
    
    private func createTemperatureLabel(_ temperature: Int, frame: CGRect) -> UILabel {
        
        let label = UILabel(frame: frame)
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = temperature.description
        
        return label
        
        
    }

*/
}
