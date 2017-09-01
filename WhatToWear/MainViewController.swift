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

class MainViewController: UIViewController {
    
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var hourlyForecastContainerView: UIView!
    
    var cityNameButton: UIButton!
    var scene = SCNScene()
    
    var character: Character!
    
    var hourlyForecastData: DataBlock!
    var todayForecastData: DataPoint!
    
    override func  viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCityButton()
        
        if character.sex != Settings.shared.characterSex {
            character.node.removeFromParentNode()
            character.changeSex()
            scene.rootNode.addChildNode(character.node)
            
            character.idle()
            
        }
        
        fetchWeatherData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCityButton()
        
        scene = SCNScene(named: "art.scnassets/Scene.scn")!
        setupEnviroment()
        
        let sex = Settings.shared.characterSex
        character = Character(sex: sex)
        scene.rootNode.addChildNode(character.node)
        character.idle()
        
        
    }
    
    func initCityButton() {
        cityNameButton = UIButton(type: .system)

        cityNameButton.frame = CGRect(x: 0, y: 0, width: 200, height: 44)
        cityNameButton.addTarget(self, action: #selector(cityNameButtonAction(_:)), for: .touchUpInside)
        self.navigationItem.titleView = cityNameButton
    }
    
    func setupCityButton() {
        
        let place = LocationServices.shared.selectedLocation
        
        if place.type == .autodetection {
            cityNameButton.setImage(#imageLiteral(resourceName: "geolocationSmall"), for: .normal)
            
            LocationServices.shared.getCurrentLocationAddress(completion: { (address, error) in
                
                if let a = address, let city = a["City"] as? String {
                    self.cityNameButton.setTitle(city, for: .normal)
                } else {
                    self.cityNameButton.setTitle("Недоступно", for: .normal)
                }
            })
            
        } else {
            let loc = place.location as? Location
            cityNameButton.setImage(#imageLiteral(resourceName: "Change City Button"), for: .normal)
            cityNameButton.setTitle(loc?.title, for: .normal)
        }
    }
    
    func setupWeatherDescription() {
        
        removeSubviewsFromHourlyForecastContainer()
        
        let dates = self.hourlyForecastData.getDates()[0]
        let blocks = self.hourlyForecastData.getWeatherBlocks()[0]
        let temperatures = self.hourlyForecastData.getTemperatures()[0]
        
        let scrollView = HourlyForecastScrollView(frame: hourlyForecastContainerView.bounds,
                                                  dates: dates,
                                                  weatherBlocks: blocks,
                                                  temperatures: temperatures,
                                                  unitSize: 80)
        
        scrollView.showsHorizontalScrollIndicator = false
        
        hourlyForecastContainerView.addSubview(scrollView)
        
        weatherDescriptionLabel.text = "Сегодня. " + todayForecastData.summary!
        
    }
    
    
    func fetchWeatherData() {
        
        if let location = LocationServices.shared.selectedLocation.location {

            let latitude = location.latitude
            let longitude = location.longitude
            
            let clientServices = ClientServices.shared
            let excludeFields: [Forecast.Field] = [.minutely, .flags, .alerts]
            clientServices.getForecast(latitude: latitude, longitude: longitude,
                                       extendHourly: true, excludeFields: excludeFields) { result in
                                        switch result {
                                        case .success(let forecast, _):
                                            
                                            DispatchQueue.main.async {
                                                
                                                self.hourlyForecastData = forecast.hourly
                                                
                                                if let todayData = forecast.daily?.data[0] {
                                                    self.todayForecastData = todayData
                                                }
                                                
                                                self.setupWeatherDescription()
                                                
                                            }
                                            
                                        case .failure(let error):
                                            self.weatherDescriptionLabel.text = "Проверьте соединение с интернетом"
                                            self.removeSubviewsFromHourlyForecastContainer()
                                            print(error.localizedDescription)
                                        }
            }
            
        } else {
            
            self.weatherDescriptionLabel.text = "Геопозиция недоступна. Выберите населенный пункт"
            removeSubviewsFromHourlyForecastContainer()
        }
        
    }
    
    //MARK: Helpers
    
    func removeSubviewsFromHourlyForecastContainer() {
        for view in hourlyForecastContainerView.subviews {
            view.removeFromSuperview()
        }
    }
    
    //MARK: SceneKit
    
    
    func setupEnviroment() {

        sceneView.scene = scene
        //sceneView.allowsCameraControl = true
        sceneView.showsStatistics = true
        sceneView.backgroundColor = UIColor.lightGray
        
    }
    
    
    @objc func cityNameButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showPlaces", sender: nil)
    }
    
    @IBAction func poweredByDarkSkyButtonAction(_ sender: Any) {
        
        ClientServices.shared.redirectToDarkSky()
        
    }
    
    

}

