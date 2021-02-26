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
    @IBOutlet weak var btnDetails: UIButton!
    
    var displayObject: TWKUserDO?
    var showDetailsHandler: ((TWKUserDO) -> Void)?
    @IBAction func detailsAction(_ sender: Any) {
        if let handler = self.showDetailsHandler,
           let displayObject = self.displayObject {
            handler(displayObject)
        }
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
          
        self.viewBg.backgroundColor = .clear
        self.viewUsername.backgroundColor = .clear

        self.imgAvatar.backgroundColor = .white
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height / 2.0

        self.btnDetails.setTitleColor(.darkGray, for: .normal)
        self.btnDetails.backgroundColor = .white
        self.btnDetails.layer.cornerRadius = self.btnDetails.frame.size.height / 2.0
        self.btnDetails.layer.borderWidth = 1.0
        self.btnDetails.layer.borderColor = UIColor.darkGray.cgColor
        
        self.imgNote.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
    func configureViewCell(displayObject: TWKUserDO, indexPath: IndexPath) {
        self.displayObject = displayObject
        self.lblUsername.text = displayObject.username
        
        if displayObject.avatarUrl.count > 0 {
            if let url = URL(string: displayObject.avatarUrl) {
                self.imgAvatar.load(
                    url: url,
                    completion: { image in
                        if indexPath.row % 4 == 0 {
                            if let inverseImage = image.inverseImage() {
                                DispatchQueue.main.async {
                                    self.imgAvatar.image = inverseImage
                                    self.imgAvatar.layer.borderWidth = 3.0
                                    self.imgAvatar.layer.borderColor = UIColor.red.cgColor
                                }
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.imgAvatar.image = image
                                self.imgAvatar.layer.borderWidth = 0
                                self.imgAvatar.layer.borderColor = UIColor.clear.cgColor
                            }
                        }
                })
            }
        }
    
    }
}
