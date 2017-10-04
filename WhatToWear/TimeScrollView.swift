//
//  TimeScrollView.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 04.10.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import UIKit

class TimeScrollView: UIScrollView {

    init(contentSize: CGSize) {
        
        super.init(frame: CGRect.zero)
        self.contentSize = contentSize
        decelerationRate = UIScrollViewDecelerationRateFast
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
