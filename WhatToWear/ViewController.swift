//
//  ViewController.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 20.07.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//



import UIKit
import ForecastIO
import SceneKit
import CoreLocation
import ASHorizontalScrollView

class ViewController: UIViewController {
    
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var cityNameButton: UIButton!
    @IBOutlet weak var poweredByDarkSkyButton: UIButton!

    
    var hourlyForecastScrollView: ASHorizontalScrollView!
    var hourlyForecastData = [DataPoint]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initViews()
        
        let locationServices = LocationServices.shared
        let latitude = locationServices.currentLocation.coordinate.latitude
        let longitude = locationServices.currentLocation.coordinate.longitude
        
        let clientServices = ClientServices.shared
        let excludeFields: [Forecast.Field] = [.minutely, .daily, .flags, .alerts]
        clientServices.getForecast(latitude: latitude, longitude: longitude, excludeFields: excludeFields) { result in
            switch result {
            case .success(let forecast, let requestMetadata):

                //print(requestMetadata)
                DispatchQueue.main.async {
                    self.hourlyForecastData = (forecast.hourly?.data)!
                    
                    self.writeViews()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        locationServices.getAdress { address, error in
            
            if let a = address, let city = a["City"] as? String {
                self.cityNameButton.titleLabel?.text = city
            }
        }
        
        

    }
    
    func initViews() {
        
        let width = bottomContainerView.frame.width
        let height = bottomContainerView.frame.height - poweredByDarkSkyButton.frame.height
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        hourlyForecastScrollView = ASHorizontalScrollView(frame: rect)
        self.bottomContainerView.addSubview(hourlyForecastScrollView)
        
    }
    
    func makeView(text: String, icon: UIImage, temperature: Float) -> UIView {
        
        let viewRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: viewRect)
        
        let labelRect = CGRect(x: 0, y: 0, width: 100, height: 20)
        let label = UILabel(frame: labelRect)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = text
        view.addSubview(label)
        
        let iconRect = CGRect(x: 0, y: 20, width: 100, height: 60)
        let iconView = UIImageView(frame: iconRect)
        iconView.contentMode = .scaleAspectFit
        iconView.image = icon
        view.addSubview(iconView)
        
        let temperatureLabelRect = CGRect(x: 0, y: 80, width: 100, height: 20)
        let temperatureLabel = UILabel(frame: temperatureLabelRect)
        temperatureLabel.textAlignment = .center
        temperatureLabel.textColor = UIColor.white
        temperatureLabel.text = "\(Int(temperature))"
        view.addSubview(temperatureLabel)
        
        return view
        
    }
    
    func writeViews() {
        
        for i in 0..<hourlyForecastData.count {
            let data = hourlyForecastData[i]
            //print(data)
            //print("\n")
            var hour = data.time.getHour()
            if i == 0 {
                hour = "Сейчас"
            }
            
            let icon = data.icon?.getImage()
            let temperature = data.temperature
            
            let view = makeView(text: hour!, icon: icon!, temperature: temperature!)
            self.hourlyForecastScrollView.addItem(view)
        
        }
        
        
    }
    
    
    @IBAction func poweredByDarkSkyButtonAction(_ sender: Any) {
        
        ClientServices.shared.redirectToDarkSky()
        
    }

    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDailyForecast") {
            let destinationVC = segue.destination as! DailyForecastTableViewController
            destinationVC.dailyForecastData = self.dailyForecastData
        }
    }*/


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

