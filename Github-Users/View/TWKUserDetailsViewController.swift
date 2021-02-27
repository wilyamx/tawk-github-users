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
    public var userDisplayObject: TWKUserDO?

    private var followersCount: Int32 = 0 {
        didSet {
            let message = "followers: \(followersCount)"
            self.lblFollowers.text = message
            self.highlightFollowCount(message: message,
                                      highlightedString: "\(followersCount)",
                                      label: self.lblFollowers)
        }
    }
    private var followingCount: Int32 = 0 {
        didSet {
            let message = "following: \(followingCount)"
            self.lblFollowing.text = message
            self.highlightFollowCount(message: message,
                                      highlightedString: "\(followingCount)",
                                      label: self.lblFollowing)
        }
    }
    private var blogUrlRange: NSRange? = nil
    
    @IBOutlet weak var imgAvatar: UIImageView!

    @IBOutlet weak var stkvFollow: UIStackView!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblBlog: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!

    @IBOutlet weak var stkvDetails: UIStackView!

    @IBOutlet weak var viewNotesBg: UIView!
    @IBOutlet weak var txtvNotes: UITextView!

    // MARK: - Actions
    
    @IBAction func saveAction(_ sender: Any) {

    }
  
    // MARK: - View Controller Life Cycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.imgAvatar.backgroundColor = .lightGray
        self.imgAvatar.contentMode = .scaleAspectFit
        
        self.stkvFollow.backgroundColor = .clear
    
        self.stkvDetails.backgroundColor = .clear
        self.stkvDetails.layer.borderWidth = 1.0
        self.stkvDetails.layer.borderColor = UIColor.black.cgColor
        
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
        
        self.followersCount = 0
        self.followingCount = 0
        
        self.lblName.text = "Name:"
        self.lblCompany.text = "Company:"
        self.lblBlog.text = "Blog:"
        
        self.btnSave.layer.cornerRadius = 5.0
        self.btnSave.backgroundColor = .red
        self.btnSave.setTitleColor(.white, for: .normal)
        self.btnSave.titleLabel?.font = UIFont.setBold(fontSize: 18.0)
        
        self.getUserProfile()
    }
    
    // MARK: - Private Methods
    
    private func getUserProfile() {
        if let userDO = self.userDisplayObject {
            self.viewModel.getUserProfile(
                username: userDO.username,
                completion: { [unowned self] profile in
                    DispatchQueue.main.async {
                        self.followersCount = profile.followers
                        self.followingCount = profile.following
                        
                        self.highlightFollowCount(
                            message: "Name: \(profile.name)",
                            highlightedString: "\(profile.name)",
                            label: self.lblName)
                        self.highlightFollowCount(
                            message: "Company: \(profile.company)",
                            highlightedString: "\(profile.company)",
                            label: self.lblCompany)
                        self.highlightFollowCount(
                            message: "Blog: \(profile.blog)",
                            highlightedString: "\(profile.blog)",
                            label: self.lblBlog)
                        
                        // blog url tap gesture
                        self.lblBlog.isUserInteractionEnabled = true
                        if let blogText = self.lblBlog.text {
                            self.blogUrlRange = (blogText as NSString).range(of: profile.blog)
                        }
                        let tapGesture = UITapGestureRecognizer(
                            target: self,
                            action: #selector(blogUrlHandler(gesture:)))
                        self.lblBlog.addGestureRecognizer(tapGesture)
                    }
                })
        }
        
    }
    
    private func highlightFollowCount(
        message: String,
        highlightedString: String,
        label: UILabel) {
        
        let messageRange = (message as NSString).range(of: message)
        let highlightRange = (message as NSString).range(of: highlightedString)
        
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont.setBold(fontSize: 20.0),
            NSAttributedString.Key.foregroundColor: UIColor.red
        ]
        let regularAttribute = [
            NSAttributedString.Key.font: UIFont.setRegular(fontSize: 16.0),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        let attributedString = NSMutableAttributedString(string: message)
        attributedString.addAttributes(regularAttribute as [NSAttributedString.Key : Any], range: messageRange)
        attributedString.addAttributes(boldAttribute as [NSAttributedString.Key : Any], range: highlightRange)
        
        label.attributedText = attributedString
    }
    
    // MARK: - Handlers
    
    @objc private func blogUrlHandler(gesture: UITapGestureRecognizer) {
        if let range = self.blogUrlRange,
           gesture.didTapAttributedTextInLabel(label: self.lblBlog, inRange: range) {
            if let blogText = self.lblBlog.text {
                let urlString = (blogText as NSString).substring(with: range)
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
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
