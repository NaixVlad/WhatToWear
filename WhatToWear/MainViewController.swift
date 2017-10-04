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



class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()
    
    var cityNameButton: UIButton!
    
    var dailyForecastData = [DataPoint]()
    var hourlyForecastData: DataBlock!
    
    var selectedIndexPath : IndexPath?
    
    let todayCell = TodayCell()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initCityButton()

        
    }
    
    override func  viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        
        setupCityButton()
        refreshWeatherData(sender: refreshControl)


    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        clipSceneView()
        if hourlyForecastData != nil {
            let dates = hourlyForecastData.getDates()[0]
            todayCell.timeScrollView.setupTimeScrollView(dates: dates, unitSize: 50)
        }
    }
    
    //MARK: tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let titles = ["Сейчас", "На неделю"]
        
        return titles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 && hourlyForecastData != nil {
            return 1
        } else {
            return self.dailyForecastData.count - 1
            //there isn't hourly format forecast on the last day
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let section = indexPath.section
            
        if row < self.dailyForecastData.count - 1 && section == 1 {
            //there is no hourly format forecast on the last day
            let identifierWeek = "forecastCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierWeek, for: indexPath) as! DayForecastCell

            setupConstantPartOfCell(cell, indexPath: indexPath)
            
            
            if selectedIndexPath == indexPath {
                setupExpandedPartOfCellFor(cell, indexPath: indexPath)
            }
            
            return cell
            
        } else {
            
            return todayCell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            let previousSelectedIndexPath = selectedIndexPath

            selectedIndexPath = indexPath
            
           tableView.reloadData()
            
            if previousSelectedIndexPath == selectedIndexPath {
                selectedIndexPath = nil
            } else {

                let cell = tableView.cellForRow(at: indexPath) as! DayForecastCell
                setupExpandedPartOfCellFor(cell, indexPath: indexPath)
                tableView.scrollToRow(at: indexPath, at: .none, animated: true)
                
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath == selectedIndexPath {
                return DayForecastCell.expandedHeight
            } else {
                return DayForecastCell.defaultHeight
            }
        } else {
            
            return TodayCell.defaultHeight
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {

            
            
        }
    }

    
    //MARK: Network
    
    private func fetchWeatherData() {
        
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
                                                
                                                self.dailyForecastData = (forecast.daily?.data)!
                                                self.hourlyForecastData = forecast.hourly!
                                                
                                                
                                                self.updateView()
                                                self.refreshControl.endRefreshing()
                                                self.activityIndicatorView.stopAnimating()
                                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                                
                                        }
                                            
                                        case .failure(let error):
                                            self.messageLabel.text = "Упс... Проверьте соединение с интернетом"
                                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                            print(error.localizedDescription)
                                            
                                            self.dailyForecastData = [DataPoint]()
                                            
                                        }
            }
            
        } else {
            
            self.messageLabel.text = "Геопозиция недоступна. Включите геопозицию или выберите местоположение самостоятельно"
            self.activityIndicatorView.stopAnimating()
            messageLabel.isHidden = false
        }
    }
    
    //MARK: Helpers
    
    
    private func initCityButton() {
        
        cityNameButton = UIButton(type: .system)
        cityNameButton.frame = CGRect(x: 0, y: 0, width: 200, height: 44)
        cityNameButton.addTarget(self, action: #selector(cityNameButtonAction(_:)), for: .touchUpInside)
        self.navigationItem.titleView = cityNameButton
        
    }
    
    private func setupTodayCell() {
        
        todayCell.selectionStyle = .none
        
        let hourData = hourlyForecastData.data.first!
        let dayData = dailyForecastData.first!
        
        todayCell.weatherDescriptionLabel.text = hourData.summary
        let temperature = Temperature(value: hourData.temperature!)
        let intTemperature = Int(temperature.value)
        todayCell.currentTemperatureLabel.text = intTemperature.description + temperature.measurement.rawValue
        
        
        
        var flag = false
        
        for i in 0...12 {
            let icon = hourlyForecastData.data[i].icon
            if icon == .rain {
                flag = true
            }
        }
        
        if flag {
            todayCell.umbrellaLabel.text = "НЕ ЗАБУДЬТЕ ЗОНТ☔️"
        } else {
            todayCell.umbrellaLabel.text = ""
        }
        
        SceneManager.shared.setupSceneWithDayData(dayData, hourData: hourData)
        SceneManager.shared.setupCharacter(hourData)
        
        todayCell.sceneView.scene = SceneManager.shared.scene
        todayCell.sceneView.showsStatistics = true
        //sceneView.allowsCameraControl = true
        
        
    }
    
    private func setupView() {
        
        setupTableView()
        setupMessageLabel()
        setupActivityIndicatorView()
        
    }
    
    private func clipSceneView() {
        
        let sceneView = todayCell.sceneView
        
        let sceneWidth = sceneView.frame.width
        let sceneHeight = sceneView.frame.height
        let trianglePadding: CGFloat = 5
        let triangleHeight: CGFloat = 30
        let triangleWidth: CGFloat = 30
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: triangleHeight))
        path.addLine(to: CGPoint(x: 0, y: sceneHeight))
        path.addLine(to: CGPoint(x: sceneWidth, y: sceneHeight))
        path.addLine(to: CGPoint(x: sceneWidth, y: triangleHeight))
        path.addLine(to: CGPoint(x: triangleWidth + trianglePadding ,y: triangleHeight))
        path.addLine(to: CGPoint(x: triangleWidth/2 + trianglePadding, y: 0))
        path.addLine(to: CGPoint(x: 5, y: triangleHeight))
        path.close()
        
        let mask = CAShapeLayer()
        mask.frame = sceneView.bounds
        mask.path = path.cgPath
        
        sceneView.layer.mask = mask;
        
    }
    
    
    private func setupTableView() {
        tableView.isHidden = true
        
        refreshControl.tintColor = UIColor.refreshControlTintColor
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(sender:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    
    private func setupMessageLabel() {
        
        messageLabel.isHidden = true
        messageLabel.text = "Загрузка..."
        
    }
    
    private func setupActivityIndicatorView() {
        
        activityIndicatorView.startAnimating()
        
    }
    
    private func updateView() {
        let hasDays = dailyForecastData.count > 0
        tableView.isHidden = !hasDays
        messageLabel.isHidden = hasDays
        
        if hasDays {
            setupTodayCell()
            tableView.reloadData()
        }
    }
    
    private func setupCityButton() {
        
        let place = LocationServices.shared.selectedLocation
        
        if place.type == .autodetection {
            cityNameButton.setImage(#imageLiteral(resourceName: "geolocationSmall"), for: .normal)
            
            LocationServices.shared.getCurrentLocationAddress(completion: { (address, error) in
                
                if let location = address {
                    self.cityNameButton.setTitle(location, for: .normal)
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
    
    private func setupConstantPartOfCell(_ cell: DayForecastCell, indexPath: IndexPath) {
        
        let row = indexPath.row
        
        let data = dailyForecastData[row]
        
        if row == 0 {
            cell.dayOfWeekLabel.text = "Сегодня"
        } else {
            cell.dayOfWeekLabel.text = data.time.dayOfWeek()!
        }
        
        cell.dateValueLabel.text = data.time.format("dd:MM:yy")
        
        let temperatureMin = Temperature(value: data.temperatureMin!)
        let temperatureMax = Temperature(value: data.temperatureMax!)
        let intTemperatureMin = Int(temperatureMin.value)
        let intTemperatureMax = Int(temperatureMax.value)
        cell.temperatureMinValueLabel.text = intTemperatureMin.description
        cell.temperatureMaxValueLabel.text = intTemperatureMax.description
        
        let image = UIImage(named: (data.icon?.rawValue)! + "Black")
        cell.iconImageView.image = image
        
    }
    
    private func setupExpandedPartOfCellFor(_ cell: DayForecastCell, indexPath: IndexPath) {
        
        let row = indexPath.row
        let data = dailyForecastData[row]
        
        let dates = hourlyForecastData.getDates()[row]
        let blocks = hourlyForecastData.getWeatherBlocks()[row]
        let temperatures = hourlyForecastData.getTemperatures()[row]
        
        let allViewsInXibArray = Bundle.main.loadNibNamed("DetailForecastView", owner: self, options: nil)
        let detailForecastView = allViewsInXibArray?.first as! DetailForecastView
        detailForecastView.frame = cell.expandableView.bounds
        cell.expandableView.addSubview(detailForecastView)
        
        let deafaultTime = "0:00"
        detailForecastView.sunriseTimeValueLabel.text = "\(data.sunriseTime?.getTime() ?? deafaultTime)"
        detailForecastView.sunsetTimeValueLabel.text = "\(data.sunsetTime?.getTime() ?? deafaultTime)"
        
        let strPrecipitationIntensity = data.precipitationIntensity?.percent.description
        detailForecastView.precipitationIntensityValueLabel.text = (strPrecipitationIntensity ?? "0") + "%"
        
        let strHumidity = data.humidity?.percent.description
        detailForecastView.humidityValueLabel.text = (strHumidity ?? "0") + "%"
        
        let windSpeed = Speed(value: data.windSpeed!)
        let speed = Int(windSpeed.value)
        detailForecastView.windSpeedValueLabel.text = speed.description + windSpeed.measurement.rawValue
        
        let defaultFloat: Float = 0.0
        let compasPoint = CompassPoint(degrees: (data.windBearing ?? defaultFloat))
        detailForecastView.windBearingValueLabel.text = compasPoint.description
        
        detailForecastView.createHourlyForecast(dates: dates,
                                                weatherBlocks: blocks,
                                                temperatures: temperatures,
                                                unitSize: 80)
        
    }
    
    
    //MARK: Actions
    
    @objc func cityNameButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showPlaces", sender: nil)
    }
    
    @objc func refreshWeatherData(sender: UIRefreshControl) {
        selectedIndexPath = nil
        setupView()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        fetchWeatherData()
    }
    
    

}

