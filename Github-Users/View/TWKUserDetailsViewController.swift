//
//  TWKUserDetailsViewController.swift
//  Github-Users
//
//  Created by William S. Rena on 2/26/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

class TWKUserDetailsViewController: TWKViewController {

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
    
        self.stkvFollow.backgroundColor = .clear
    
        self.stkvDetails.backgroundColor = .clear
        
        self.viewNotesBg.backgroundColor = .clear
        
        if let displayObject = self.userDisplayObject {
          self.title = displayObject.username
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
