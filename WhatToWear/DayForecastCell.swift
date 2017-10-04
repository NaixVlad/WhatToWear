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
    
    @IBOutlet weak var expandableView: UIView!

    @IBOutlet weak var temperatureMaxValueLabel: UILabel!
    @IBOutlet weak var temperatureMinValueLabel: UILabel!

    class var expandedHeight: CGFloat { get { return 390 } }
    class var defaultHeight: CGFloat  { get { return 75  } }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

