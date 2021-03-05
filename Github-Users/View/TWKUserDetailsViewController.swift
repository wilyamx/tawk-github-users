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
    public var userProfileDisplayObject: TWKUserProfileDO?
    
    public var delegate: TWKUsersViewProtocol?
    
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
    private var savedNote: String = ""
    
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
        // allow save note if there's a changes in the note value
        guard self.txtvNotes.text.count > 0,
              self.txtvNotes.text != self.savedNote else { return }
        
        TWKPopupManager.shared.popUpConfirmation(
            presenter: self,
            title: "Alert",
            message: "Save current note changes?",
            confirmed: {
                if let displayObject = self.userProfileDisplayObject {
                    self.viewModel.userCreateOrUpdateNote(
                        userId: displayObject.id,
                        message: self.txtvNotes.text,
                        completion: { noteDisplayObject in
                            self.savedNote = noteDisplayObject.message

                            self.delegate?.updateNoteStatus(displayObject: displayObject)
                            
                            if let barButtonItem = self.navigationItem.leftBarButtonItem {
                                self.onBackHandler(sender: barButtonItem)
                            }
                        })
                }
            })
    }
  
    // MARK: - View Controller Life Cycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // customize the navigation back button
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(self.onBackHandler(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        self.imgAvatar.backgroundColor = .lightGray
        self.imgAvatar.contentMode = .scaleAspectFit
        
        self.stkvFollow.backgroundColor = .clear
    
        self.stkvDetails.backgroundColor = .clear
        self.stkvDetails.layer.borderWidth = 1.0
        self.stkvDetails.layer.borderColor = UIColor.black.cgColor
        
        self.viewNotesBg.backgroundColor = .clear
        self.txtvNotes.layer.borderWidth = 1.0
        self.txtvNotes.layer.borderColor = UIColor.black.cgColor
        self.txtvNotes.text = ""
        self.txtvNotes.delegate = self
        
        if let displayObject = self.userProfileDisplayObject {
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
        
        if let userDO = self.userProfileDisplayObject {
            DispatchQueue.main.async {
                self.followersCount = userDO.followers
                self.followingCount = userDO.following
                
                self.highlightFollowCount(
                    message: "Name: \(userDO.name)",
                    highlightedString: "\(userDO.name)",
                    label: self.lblName)
                self.highlightFollowCount(
                    message: "Company: \(userDO.company)",
                    highlightedString: "\(userDO.company)",
                    label: self.lblCompany)
                self.highlightFollowCount(
                    message: "Blog: \(userDO.blog)",
                    highlightedString: "\(userDO.blog)",
                    label: self.lblBlog)
                
                // blog url tap gesture
                self.lblBlog.isUserInteractionEnabled = true
                if let blogText = self.lblBlog.text {
                    self.blogUrlRange = (blogText as NSString).range(of: userDO.blog)
                }
                let tapGesture = UITapGestureRecognizer(
                    target: self,
                    action: #selector(self.blogUrlHandler(gesture:)))
                self.lblBlog.addGestureRecognizer(tapGesture)
            }
        }
        
        self.getNote()
        self.seenUser()
        self.registerForKeyboardObservers()
    }
    
    // MARK: - Private Methods
    
    private func getUserProfile() {
        if let userDO = self.userProfileDisplayObject {
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
    
    private func getNote() {
        if let userDO = self.userProfileDisplayObject {
            self.viewModel.getNote(
                userId: userDO.id,
                completion: { displayObject in
                    DispatchQueue.main.async {
                        self.txtvNotes.text = displayObject.message
                        self.savedNote = displayObject.message
                    }
                })
        }
    }
    
    private func seenUser() {
        if let userDO = self.userProfileDisplayObject {
            self.viewModel.userSeenProfile(
                userId: userDO.id,
                completion: {
                    self.delegate?.updateSeenStatus(displayObject: userDO)
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
    
    @objc private func onBackHandler(sender: UIBarButtonItem) {
        self.unregisterForKeyboardObservers()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func blogUrlHandler(gesture: UITapGestureRecognizer) {
        guard TWKNetworkManager.shared.isConnectedToNetwork() else { return }
        
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

extension TWKUserDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.activeTextInput = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.activeTextInput = nil
    }
}
