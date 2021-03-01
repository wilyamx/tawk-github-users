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
    @IBOutlet weak var actDetails: UIActivityIndicatorView!
    
    var displayObject: TWKUserDO?
    var showDetailsHandler: ((TWKUserDO) -> Void)?
    @IBAction func detailsAction(_ sender: Any) {
        if let handler = self.showDetailsHandler,
           let displayObject = self.displayObject {
            self.actDetails.isHidden = false
            self.actDetails.startAnimating()
            
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 2.0,
                execute: {
                    self.actDetails.stopAnimating()
                    self.actDetails.isHidden = true
                })
            
            handler(displayObject)
        }
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .white
        
        self.viewBg.backgroundColor = .clear
        self.viewUsername.backgroundColor = .clear

        self.imgAvatar.backgroundColor = .white
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height / 2.0
        self.imgAvatar.image = UIImage(named: "avatar-placeholder")
        
        self.btnDetails.setTitleColor(.darkGray, for: .normal)
        self.btnDetails.backgroundColor = .white
        self.btnDetails.layer.cornerRadius = self.btnDetails.frame.size.height / 2.0
        self.btnDetails.layer.borderWidth = 1.0
        self.btnDetails.layer.borderColor = UIColor.darkGray.cgColor
        
        self.imgNote.isHidden = true
        self.actDetails.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
    func configureViewCell(displayObject: TWKUserDO, indexPath: IndexPath) {
        self.displayObject = displayObject
        self.lblUsername.text = displayObject.username
        
        self.imgAvatar.image = UIImage(named: "avatar-placeholder")
        self.imgAvatar.layer.borderWidth = 0
        self.imgAvatar.layer.borderColor = UIColor.clear.cgColor
        
        if indexPath.row % 4 == 0 {
            DispatchQueue.main.async {
                self.imgAvatar.layer.borderWidth = 3.0
                self.imgAvatar.layer.borderColor = UIColor.red.cgColor
            }
        }
        else {
            DispatchQueue.main.async {
                self.imgAvatar.layer.borderWidth = 0
                self.imgAvatar.layer.borderColor = UIColor.clear.cgColor
            }
        }
        
        if displayObject.avatarUrl.count > 0 {
            if let url = URL(string: displayObject.avatarUrl) {
                self.imgAvatar.load(
                    url: url,
                    completion: { image in
                       
                    if indexPath.row % 4 == 0 {
                        if let inverseImage = image.inverseImage() {
                            DispatchQueue.main.async {
                                self.imgAvatar.image = inverseImage
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.imgAvatar.image = image
                        }
                    }
                })
            }
        }
        
        self.imgNote.isHidden = !(displayObject.hasNote ?? false)
        
        self.contentView.backgroundColor = displayObject.hasSeen ?? false ? UIColor.lightGray : UIColor.white
    }
}
