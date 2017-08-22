//
//  SettingsViewController.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 20.08.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var temperatureMeasurementSegmentedControl: UISegmentedControl!

    @IBOutlet weak var speedMeasurementSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var pressureMeasurementSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var characterSexSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let temperature = Settings.shared.temperatureMeasurement
        switch temperature {
            case .degreesCelsius:
                temperatureMeasurementSegmentedControl.selectedSegmentIndex = 0
            case .degreesFahrenheit:
                temperatureMeasurementSegmentedControl.selectedSegmentIndex = 1
        }
        
        let speed = Settings.shared.speedMeasurement
        switch speed {
            case .metersPerHour:
                speedMeasurementSegmentedControl.selectedSegmentIndex = 0
            case .kilometersPerHour:
                speedMeasurementSegmentedControl.selectedSegmentIndex = 1
            case .milesPerHour:
                speedMeasurementSegmentedControl.selectedSegmentIndex = 2
        }
        
        let pressure = Settings.shared.pressureMeasurement
        switch pressure {
            case .millimetersOfMercury:
                pressureMeasurementSegmentedControl.selectedSegmentIndex = 0
            case .hectopascals:
                pressureMeasurementSegmentedControl.selectedSegmentIndex = 1
        }
        
        let sex = Settings.shared.characterSex
        switch sex {
            case .male:
                characterSexSegmentedControl.selectedSegmentIndex = 0
            case .female:
                characterSexSegmentedControl.selectedSegmentIndex = 1
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func temperatureMeasurementValueChanged(_ sender: UISegmentedControl) {
        let selectedSegment = sender.selectedSegmentIndex
        let title = sender.titleForSegment(at: selectedSegment)
        
        Settings.shared.temperatureMeasurement = TemperatureMeasurement(rawValue: title!)!
        
    }
    
    @IBAction func speedMeasurementValueChanged(_ sender: UISegmentedControl) {
        
        let selectedSegment = sender.selectedSegmentIndex
        let title = sender.titleForSegment(at: selectedSegment)
        
        Settings.shared.speedMeasurement = SpeedMeasurement(rawValue: title!)!
        
        
    }
    
    @IBAction func pressureMeasurementValueChanged(_ sender: UISegmentedControl) {
        
        let selectedSegment = sender.selectedSegmentIndex
        let title = sender.titleForSegment(at: selectedSegment)
        
        Settings.shared.pressureMeasurement = PressureMeasurement(rawValue: title!)!
        
    }
    
    @IBAction func characterSexValueChanged(_ sender: UISegmentedControl) {
        
        let selectedSegment = sender.selectedSegmentIndex
        
        Settings.shared.characterSex = Sex(rawValue: selectedSegment)!
        
    }
    
    @IBAction func notificationsValueChanged(_ sender: UISwitch) {
        
        
        
    }
    
}
