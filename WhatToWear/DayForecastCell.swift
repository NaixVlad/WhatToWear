//
//  DayForecastCell.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 23.07.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import UIKit

class DayForecastCell: UITableViewCell {

    
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
    
    class var expandedHeight: CGFloat { get { return 300 } }
    class var defaultHeight: CGFloat  { get { return 75  } }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
