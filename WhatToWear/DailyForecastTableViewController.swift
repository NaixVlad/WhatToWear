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

        // Configure Refresh Control
        refreshControl.tintColor = refreshControlTintColor
        refreshControl.addTarget(self, action: #selector(DailyForecastViewController.refreshWeatherData(sender:)), for: .valueChanged)
        
        // Add to Table View
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
    
    func refreshWeatherData(sender: UIRefreshControl) {
        fetchWeatherData()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Helper Methods
    
    private func fetchWeatherData() {
        
        let locationServices = LocationServices.shared
        let latitude = locationServices.currentLocation.coordinate.latitude
        let longitude = locationServices.currentLocation.coordinate.longitude
        
        let clientServices = ClientServices.shared
        let excludeFields: [Forecast.Field] = [.minutely, .flags, .alerts]
        clientServices.getForecast(latitude: latitude, longitude: longitude,
                                   extendHourly: true, excludeFields: excludeFields) { result in
                                    switch result {
                                    case .success(let forecast, let requestMetadata):
                                        
                                        //print(requestMetadata)
                                        
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
        
    }
    
    
    
    
}

// MARK: - Table view data source

extension DailyForecastViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
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
            
            print(blocks.count)
            
            let rect = cell.scrollViewContainer.frame
            let scrollView = HourlyForecastScrollView(frame: rect, data: blocks, dates: dates)
            cell.addSubview(scrollView)
            
            //print(dates.count)
            //cell.hourlyForecastScrollView.createTimeLine(dates[row])
            
            cell.dayOfWeekLabel.text = data.time.dayOfWeek()!
            cell.dateValueLabel.text = "\(data.time)"
            cell.temperatureMinValueLabel.text = "\(Int(data.temperatureMin!))"
            cell.temperatureMaxValueLabel.text = "\(Int(data.temperatureMax!))"
            
            cell.sunriseTimeValueLabel.text = "\(data.sunriseTime?.getTime() ?? "0:00")"
            cell.sunsetTimeValueLabel.text = "\(data.sunsetTime?.getTime() ?? "0:00")"
            
            cell.precipitationIntensityValueLabel.text = "\(data.precipitationIntensity ?? 0)"
            cell.humidityValueLabel.text = "\(data.humidity ?? 0)"
            
            cell.windSpeedValueLabel.text = "\(data.windSpeed ?? 0)"
            cell.windBearingValueLabel.text = "\(data.windBearing ?? 0)"
            
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
