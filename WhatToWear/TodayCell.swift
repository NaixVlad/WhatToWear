//
//  TodayCell.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 04.10.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import UIKit
import SceneKit

class TodayCell: UITableViewCell {
    
    
    class var defaultHeight: CGFloat  { get { return 500  } }
    
    let weatherDescriptionLabel = UILabel()
    let sceneView = SCNView()
    let currentTemperatureLabel = UILabel()
    let timeScrollView = HourlyForecastScrollView()
    let umbrellaLabel = UILabel()
    
    init() {
        
        super.init(style: .default, reuseIdentifier: nil)
        
        self.addSubview(sceneView)
        self.addSubview(weatherDescriptionLabel)
        self.addSubview(currentTemperatureLabel)
        self.addSubview(timeScrollView)
        self.addSubview(umbrellaLabel)
        
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        weatherDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        timeScrollView.translatesAutoresizingMaskIntoConstraints = false
        umbrellaLabel.translatesAutoresizingMaskIntoConstraints = false
        
        currentTemperatureLabel.textColor = UIColor.darkGray
        currentTemperatureLabel.font.withSize(35)
        currentTemperatureLabel.textAlignment = .right
        
        umbrellaLabel.textColor = UIColor.darkGray
        umbrellaLabel.font = UIFont(name: "Helvetica-Bold", size: 14)
        umbrellaLabel.textAlignment = .right
        
        timeScrollView.showsHorizontalScrollIndicator = false
        timeScrollView.decelerationRate = UIScrollViewDecelerationRateFast
        
        //SceneView
        let bottomSceneView = NSLayoutConstraint(item: sceneView, attribute: .bottom,
                                                 relatedBy: .equal,
                                                 toItem: self, attribute: .bottom,
                                                 multiplier: 1, constant: 0)
        
        let trailingSceneView = NSLayoutConstraint(item: sceneView, attribute: .trailing,
                                                   relatedBy: .equal,
                                                   toItem: self, attribute: .trailing,
                                                   multiplier: 1, constant: 0)
        
        let leadingSceneView = NSLayoutConstraint(item: sceneView, attribute: .leading,
                                                  relatedBy: .equal,
                                                  toItem: self, attribute: .leading,
                                                  multiplier: 1, constant: 0)
        
        
        let heightSceneView = NSLayoutConstraint(item: sceneView, attribute: .height,
                                                 relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute,
                                                 multiplier: 1, constant: 400)
        
        //WeatherDescriptionLabel
        
        let topWeatherDescriptionLabel = NSLayoutConstraint(item: weatherDescriptionLabel,
                                                            attribute: .top,
                                                            relatedBy: .equal,
                                                            toItem: self,
                                                            attribute: .top,
                                                            multiplier: 1, constant: 0)
        
        let leadingWeatherDescriptionLabel = NSLayoutConstraint(item: weatherDescriptionLabel,
                                                                attribute: .leading,
                                                                relatedBy: .equal,
                                                                toItem: self,
                                                                attribute: .leading,
                                                                multiplier: 1, constant: 16)
        
        let bottomWeatherDescriptionLabel = NSLayoutConstraint(item: weatherDescriptionLabel,
                                                               attribute: .bottom,
                                                               relatedBy: .equal,
                                                               toItem: timeScrollView,
                                                               attribute: .top,
                                                               multiplier: 1, constant: 0)
        
        
        
        
        //currentTemperatureLabel
        
        let topCurrentTemperatureLabel = NSLayoutConstraint(item: currentTemperatureLabel,
                                                            attribute: .top,
                                                            relatedBy: .equal,
                                                            toItem: self,
                                                            attribute: .top,
                                                            multiplier: 1, constant: 0)
        
        
        let leadingCurrentTemperatureLabel = NSLayoutConstraint(item: currentTemperatureLabel,
                                                                 attribute: .leading,
                                                                 relatedBy: .equal,
                                                                 toItem: weatherDescriptionLabel,
                                                                 attribute: .trailing,
                                                                 multiplier: 1, constant: 0)
        
        let trailingCurrentTemperatureLabel = NSLayoutConstraint(item: currentTemperatureLabel,
                                                                 attribute: .trailing,
                                                                 relatedBy: .equal,
                                                                 toItem: self,
                                                                 attribute: .trailing,
                                                                 multiplier: 1, constant: -16)
        
        let bottomCurrentTemperatureLabel =  NSLayoutConstraint(item: currentTemperatureLabel,
                                                                attribute: .bottom,
                                                                relatedBy: .equal,
                                                                toItem: timeScrollView,
                                                                attribute: .top,
                                                                multiplier: 1, constant: 0)
        
        let widthCurrentTemperatureLabel =  NSLayoutConstraint(item: currentTemperatureLabel,
                                                               attribute: .width,
                                                               relatedBy: .equal,
                                                               toItem: nil,
                                                               attribute: .notAnAttribute,
                                                               multiplier: 1, constant: 50)
        
        
        //timeScrollView
        
        let trailingTimeScrollView = NSLayoutConstraint(item: timeScrollView,
                                                        attribute: .trailing,
                                                        relatedBy: .equal,
                                                        toItem: self,
                                                        attribute: .trailing,
                                                        multiplier: 1, constant: 0)
        
        let leadingTimeScrollView = NSLayoutConstraint(item: timeScrollView,
                                                       attribute: .leading,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute: .leading,
                                                       multiplier: 1, constant: 0)
        
        let bottomTimeScrollView = NSLayoutConstraint(item: timeScrollView,
                                                      attribute: .bottom,
                                                      relatedBy: .equal,
                                                      toItem: sceneView,
                                                      attribute: .top,
                                                      multiplier: 1, constant: 0)
        
        let heightTimeScrollView = NSLayoutConstraint(item: timeScrollView,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .notAnAttribute,
                                                      multiplier: 1, constant: 50)
        
        //umbrellaLabel
        
        let topWeatherUmbrellaLabel = NSLayoutConstraint(item: umbrellaLabel,
                                                            attribute: .top,
                                                            relatedBy: .equal,
                                                            toItem: sceneView,
                                                            attribute: .top,
                                                            multiplier: 1, constant: 0)
        
        let trailingUmbrellaLabel = NSLayoutConstraint(item: umbrellaLabel,
                                                        attribute: .trailing,
                                                        relatedBy: .equal,
                                                        toItem: self,
                                                        attribute: .trailing,
                                                        multiplier: 1, constant: -16)
        
        let heightUmbrellaLabel =  NSLayoutConstraint(item: umbrellaLabel,
                                                                attribute: .height,
                                                                relatedBy: .equal,
                                                                toItem: nil,
                                                                attribute: .notAnAttribute,
                                                                multiplier: 1, constant: 30)
        
        let widthUmbrellaLabel =  NSLayoutConstraint(item: umbrellaLabel,
                                                               attribute: .width,
                                                               relatedBy: .equal,
                                                               toItem: nil,
                                                               attribute: .notAnAttribute,
                                                               multiplier: 1, constant: 200)
        
        
        NSLayoutConstraint.activate([bottomSceneView, trailingSceneView,
                                     leadingSceneView, heightSceneView,
                                     topWeatherDescriptionLabel, leadingCurrentTemperatureLabel,
                                     leadingWeatherDescriptionLabel, bottomWeatherDescriptionLabel,
                                     bottomCurrentTemperatureLabel,topCurrentTemperatureLabel,
                                     trailingCurrentTemperatureLabel, heightTimeScrollView,
                                     widthCurrentTemperatureLabel, trailingTimeScrollView,
                                     leadingTimeScrollView, bottomTimeScrollView,
                                     topWeatherUmbrellaLabel, trailingUmbrellaLabel,
                                     heightUmbrellaLabel, widthUmbrellaLabel])
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
