//
//  TWKHiddenView.swift
//  Github-Users
//
//  Created by William S. Rena on 2/27/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

class TWKHiddenView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.isHidden = false
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
    }
}
