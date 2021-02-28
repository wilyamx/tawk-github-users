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
  
    private lazy var viewModel = TWKUsersViewModel()
    private var users: [TWKUserDO] = [TWKUserDO]()
    private var usersFiltered: [TWKUserDO] = [TWKUserDO]()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearchBarEmpty: Bool {
        return self.searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Github users"
        
        self.view.backgroundColor = .white
        self.enableRefreshControl(tableView: self.tblUsers)
        
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
        self.tblUsers.separatorStyle = .singleLine
        self.tblUsers.backgroundColor = .white
        
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search"

        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    private func getUsers() {
        self.viewModel.pullDown(
            completion: { users in
                DispatchQueue.main.async {
                    self.users = users
                    
                    self.tblUsers.reloadData()
                    self.refreshControl.endRefreshing()
                }
            },
            otherStatusComplete: { users in
                DispatchQueue.main.async {
                    for user in self.users {
                        for userNoteStatus in users {
                            if user.id == userNoteStatus.id {
                                user.hasNote = userNoteStatus.hasNote
                                user.hasSeen = userNoteStatus.hasSeen
                                break
                            }
                        }
                    }
                    
                    self.tblUsers.reloadData()
                    self.refreshControl.endRefreshing()
                }
            })
    }
    
    private func getNextUsers() {
        self.viewModel.pullUp(
            completion: { users in
                DispatchQueue.main.async {
                    self.users.append(contentsOf: users)
                    
                    self.tblUsers.tableFooterView = UIView()
                    self.tblUsers.reloadData()
                }
            },
            otherStatusComplete: { users in
                DispatchQueue.main.async {
                    for user in self.users {
                        for userNoteStatus in users {
                            if user.id == userNoteStatus.id {
                                user.hasNote = userNoteStatus.hasNote
                                user.hasSeen = userNoteStatus.hasSeen
                                break
                            }
                        }
                    }
                    
                    self.tblUsers.reloadData()
                    self.refreshControl.endRefreshing()
                }
            })
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        self.usersFiltered = self.users.filter { (user: TWKUserDO) -> Bool in
            return user.username.lowercased().contains(searchText.lowercased())
        }
      
        DispatchQueue.main.async {
            self.tblUsers.reloadData()
        }
    }
    
    // MARK: - Handlers
    
    override func refreshData(_ sender: Any) {
        self.updateOfflineIndicator()
        self.getUsers()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TWKUserDetailsViewController,
           let displayObject = sender as? TWKUserDO,
           segue.identifier == TWKScreen.userDetails.segueIdentifier {
            vc.userDisplayObject = displayObject
            vc.delegate = self
        }
    }

}

extension TWKUsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isFiltering {
            return self.usersFiltered.count
        }
        return self.users.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data: TWKUserDO
        if self.isFiltering {
            data = self.usersFiltered[indexPath.row]
        }
        else {
            data = self.users[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TWKUserTableViewCell.self),
            for: indexPath) as! TWKUserTableViewCell
        cell.selectionStyle = .none
        cell.configureViewCell(displayObject: data, indexPath: indexPath)
        cell.showDetailsHandler = { [unowned self] displayObject in
            self.performSegue(withIdentifier: TWKScreen.userDetails.segueIdentifier,
                              sender: displayObject)
        }
        return cell
    }
}

extension TWKUsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let data = self.users[indexPath.row]
      print("\(DebugInfoKey.users.rawValue) selected a message :: \(data.username) at index (\(indexPath.row))")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // pull-up
        if (self.tblUsers.contentOffset.y + self.tblUsers.frame.size.height) >= self.tblUsers.contentSize.height {
             DispatchQueue.main.async {
                let spinner = UIActivityIndicatorView(style: .medium)
                spinner.color = UIColor.red
                spinner.hidesWhenStopped = true
                self.tblUsers.tableFooterView = spinner
                
                spinner.startAnimating()
                self.getNextUsers()
             }
        }
    }
}

extension TWKUsersViewController: UISearchBarDelegate {
    
}

extension TWKUsersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // If the search bar contains text, filter our data with the string
        if let searchText = searchController.searchBar.text {
            self.filterContentForSearchText(searchText)
        }
    }
}

extension TWKUsersViewController: TWKUsersViewProtocol {
    func updateNoteStatus(displayObject: TWKUserDO) {
        if let displayObject = self.users.first(where: { $0.id == displayObject.id }) {
            DispatchQueue.main.async {
                displayObject.hasNote = true
                self.tblUsers.reloadData()
            }
        }
    }
    
    func updateSeenStatus(displayObject: TWKUserDO) {
        if let displayObject = self.users.first(where: { $0.id == displayObject.id }) {
            DispatchQueue.main.async {
                displayObject.hasSeen = true
                self.tblUsers.reloadData()
            }
        }
    }
    
}
