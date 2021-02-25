//
//  TWKUsersViewController.swift
//  Github-Users
//
//  Created by William S. Rena on 2/25/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

class TWKUsersViewController: TWKViewController {
    
    @IBOutlet weak var tblUsers: UITableView!
  
    public lazy var viewModel = TWKUsersViewModel()
    
    private var users: [TWKUserDO] = [TWKUserDO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeUI()
        self.getUsers()
    }
    
    // MARK: - Private Methods
    
    private func initializeUI() {
        self.tblUsers.register(UINib(nibName: "TWKUserTableViewCell",
                                 bundle: Bundle.main),
                        forCellReuseIdentifier: String(describing: TWKUserTableViewCell.self))
        
        self.tblUsers.rowHeight = UITableView.automaticDimension
        self.tblUsers.estimatedRowHeight = 10
        self.tblUsers.allowsMultipleSelection = false
        
        self.tblUsers.dataSource = self
        self.tblUsers.delegate = self
        self.tblUsers.tableHeaderView = UIView()
        self.tblUsers.tableFooterView = UIView()
        self.tblUsers.separatorStyle = .none
        self.tblUsers.backgroundColor = self.view.backgroundColor
    }
    
    private func getUsers() {
        self.viewModel.getUsers(completion: { users in
            self.users = users
            
            DispatchQueue.main.async {
                self.tblUsers.reloadData()
            }
        })
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

extension TWKUsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.users[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TWKUserTableViewCell.self),
            for: indexPath) as! TWKUserTableViewCell
        
        cell.selectionStyle = .none
//        cell.configureViewCell(displayObject: data,
//                               loginUserId: self.loginUserId)
        return cell
    }
}

extension TWKUsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let data = self.users[indexPath.row]
      print("\(DebugInfoKey.database.rawValue) selected a message :: \(data.username) at index (\(indexPath.row))")
    }
}
