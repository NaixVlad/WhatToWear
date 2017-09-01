//
//  DailyForecastViewController.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 22.07.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import UIKit
import ForecastIO


class DailyForecastViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var dailyForecastData = [DataPoint]()
    var hourlyForecastData: DataBlock!
    
    var selectedIndexPath : IndexPath?
    
    private let refreshControl = UIRefreshControl()
    private let refreshControlTintColor = UIColor(red:0.51, green:0.51, blue:0.51, alpha:1.0)
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        fetchWeatherData()

    }

    
    // MARK: - View Methods
    
    private func setupView() {
        setupTableView()
        setupMessageLabel()
        setupActivityIndicatorView()
    }
    
    private func updateView() {
        let hasDays = dailyForecastData.count > 0
        tableView.isHidden = !hasDays
        messageLabel.isHidden = hasDays
        
        if hasDays {
            tableView.reloadData()
        }
    }
    
    // MARK: -
    
    private func setupTableView() {
        tableView.isHidden = true

        refreshControl.tintColor = refreshControlTintColor
        refreshControl.addTarget(self, action: #selector(DailyForecastViewController.refreshWeatherData(sender:)), for: .valueChanged)
        
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
    
    // MARK: - Actions
    
    @objc func refreshWeatherData(sender: UIRefreshControl) {
        fetchWeatherData()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Helper Methods
    
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
                                                self.hourlyForecastData = forecast.hourly
                                                
                                                self.updateView()
                                                self.refreshControl.endRefreshing()
                                                self.activityIndicatorView.stopAnimating()
                                                
                                            }
                                            
                                        case .failure(let error):
                                            self.messageLabel.text = "Упс... Проверьте соединение с интернетом"
                                            print(error.localizedDescription)
                                        }
            }
        
        } else {
            
            self.messageLabel.text = "Геопозиция недоступна. Включите геопозицию или выберите местоположение самостоятельно"
            self.activityIndicatorView.stopAnimating()
            messageLabel.isHidden = false
        }
    }
    
}


extension DailyForecastViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dailyForecastData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let row = indexPath.row
        
        if row < self.dailyForecastData.count - 1 { //On the last day there is no hourly format forecast
            
            let identifier = "forecastCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DayForecastCell
            
            let data = dailyForecastData[row]
            
            let dates = self.hourlyForecastData.getDates()[row]
            let blocks = self.hourlyForecastData.getWeatherBlocks()[row]
            let temperatures = self.hourlyForecastData.getTemperatures()[row]

            cell.createHourlyForecast(dates: dates,
                                      weatherBlocks: blocks,
                                      temperatures: temperatures,
                                      unitSize: 80)
            
            if row == 0 {
                cell.dayOfWeekLabel.text = "Сегодня"
            } else {
                cell.dayOfWeekLabel.text = data.time.dayOfWeek()!
            }

            cell.dateValueLabel.text = data.time.format("dd:MM:yy")
            
            let defaultFloat: Float = 0.0
            let temperatureMin = Temperature(value: data.temperatureMin!)
            let temperatureMax = Temperature(value: data.temperatureMax!)
            let intTemperatureMin = Int(temperatureMin.value)
            let intTemperatureMax = Int(temperatureMax.value)
            cell.temperatureMinValueLabel.text = intTemperatureMin.description
            cell.temperatureMaxValueLabel.text = intTemperatureMax.description
            
            let deafaultTime = "0:00"
            cell.sunriseTimeValueLabel.text = "\(data.sunriseTime?.getTime() ?? deafaultTime)"
            cell.sunsetTimeValueLabel.text = "\(data.sunsetTime?.getTime() ?? deafaultTime)"
            
            let strPrecipitationIntensity = data.precipitationIntensity?.percent.description 
            cell.precipitationIntensityValueLabel.text = (strPrecipitationIntensity ?? "0") + "%"
            
            let strHumidity = data.humidity?.percent.description
            cell.humidityValueLabel.text = (strHumidity ?? "0") + "%"
            
            let windSpeed = Speed(value: data.windSpeed!)
            let speed = Int(windSpeed.value)
            cell.windSpeedValueLabel.text = speed.description + windSpeed.measurement.rawValue
            
            let compasPoint = CompassPoint(degrees: (data.windBearing ?? defaultFloat))
            cell.windBearingValueLabel.text = compasPoint.description
            
            let image = UIImage(named: (data.icon?.rawValue)! + "Black")
            cell.iconImageView.image = image
            
            return cell
            
        } else {
            
            let identifier = "poweredByDarkSkyCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            
            let poweredByDarkSkyView = UIImageView(image: #imageLiteral(resourceName: "poweredby-oneline"))
            poweredByDarkSkyView.contentMode = .scaleAspectFit
            let rect = CGRect(origin: CGPoint.zero, size: cell.frame.size)
            poweredByDarkSkyView.frame = rect
            cell.addSubview(poweredByDarkSkyView)
            
            return cell
            
        }
        
    }
    
    // MARK: - Table view delegate
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let previousSelectedIndexPath = selectedIndexPath
        
        let row = indexPath.row
        if row == self.dailyForecastData.count {
            ClientServices.shared.redirectToDarkSky()
        } else {
            selectedIndexPath = indexPath
        }
        
        if previousSelectedIndexPath == selectedIndexPath {
            selectedIndexPath = nil
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       if indexPath == selectedIndexPath {
            return DayForecastCell.expandedHeight
        } else {
            return DayForecastCell.defaultHeight
        }
    }
    
}
