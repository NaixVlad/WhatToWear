//
//  DayForecastCell.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 23.07.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import UIKit

class DayForecastCell: UITableViewCell  {

    
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    
    @IBOutlet weak var dateValueLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var scrollViewContainer: UIView!
    
    @IBOutlet weak var temperatureMaxValueLabel: UILabel!
    @IBOutlet weak var temperatureMinValueLabel: UILabel!
    
    @IBOutlet weak var sunriseTimeValueLabel: UILabel!
    @IBOutlet weak var sunsetTimeValueLabel: UILabel!
    
    @IBOutlet weak var precipitationIntensityValueLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    
    @IBOutlet weak var windSpeedValueLabel: UILabel!
    @IBOutlet weak var windBearingValueLabel: UILabel!

    class var expandedHeight: CGFloat { get { return 390 } }
    class var defaultHeight: CGFloat  { get { return 75  } }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for view in scrollViewContainer.subviews {
            view.removeFromSuperview()
        }
    }
    
    func createHourlyForecast(dates: [Date], weatherBlocks: [WeatherBlock],
                              temperatures: [Float], unitSize: CGFloat) {
        
        let width = self.contentView.frame.width
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
    

}

