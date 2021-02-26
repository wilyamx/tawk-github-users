//
//  TWKUserDetailsViewController.swift
//  Github-Users
//
//  Created by William S. Rena on 2/26/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

class TWKUserDetailsViewController: TWKViewController {

    public lazy var viewModel = TWKUserDetailsViewModel()
    var userDisplayObject: TWKUserDO?
    
    
    @IBOutlet weak var imgAvatar: UIImageView!

    @IBOutlet weak var stkvFollow: UIStackView!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var btnSave: UIButton!

    @IBOutlet weak var stkvDetails: UIStackView!

    @IBOutlet weak var viewNotesBg: UIView!
    @IBOutlet weak var txtvNotes: UITextView!

    @IBAction func saveAction(_ sender: Any) {

    }
  
    // MARK: - View Controller Life Cycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.imgAvatar.backgroundColor = .lightGray
        self.imgAvatar.contentMode = .scaleAspectFit
        
        self.stkvFollow.backgroundColor = .clear
    
        self.stkvDetails.backgroundColor = .clear
        
        self.viewNotesBg.backgroundColor = .clear
        self.txtvNotes.layer.borderWidth = 1.0
        self.txtvNotes.layer.borderColor = UIColor.black.cgColor
        
        if let displayObject = self.userDisplayObject {
            self.title = displayObject.username
            
            if displayObject.avatarUrl.count > 0 {
                if let url = URL(string: displayObject.avatarUrl) {
                    self.imgAvatar.load(
                        url: url,
                        completion: { image in
                            DispatchQueue.main.async {
                                self.imgAvatar.contentMode = .scaleAspectFill
                                self.imgAvatar.image = image
                            }
                        })
                }
            }
            
        }
        
    }
    
    // MARK: - Private Methods
    
    private func getOrganizationDetails() {
        if let userDO = self.userDisplayObject {
            self.viewModel.getOrganizationDetails(
                organizationsUrl: userDO.organizationsUrl,
                completion: { organization in
                    print("]>>")
                })
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
