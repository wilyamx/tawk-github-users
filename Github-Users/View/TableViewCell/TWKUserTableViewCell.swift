//
//  TWKUserTableViewCell.swift
//  Github-Users
//
//  Created by William S. Rena on 2/25/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

class TWKUserTableViewCell: UITableViewCell {

  @IBOutlet weak var viewBg: UIView!
  @IBOutlet weak var imgAvatar: UIImageView!
  @IBOutlet weak var lblUsername: UILabel!
  @IBOutlet weak var imgNote: UIImageView!
  @IBOutlet weak var viewUsername: UIView!
    
  @IBAction func detailsAction(_ sender: Any) {
    
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
      
    self.viewBg.backgroundColor = .clear
    self.viewUsername.backgroundColor = .clear
    
    self.imgAvatar.backgroundColor = .white
    self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height / 2.0
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
  }
  
  func configureViewCell(displayObject: TWKUserDO) {
    self.lblUsername.text = displayObject.username
  }
}
