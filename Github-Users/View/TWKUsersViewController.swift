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
    private var usersFiltered: [TWKUserDO] = [TWKUserDO]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
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
        
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search"

        self.navigationItem.searchController = searchController
        self.navigationItem.largeTitleDisplayMode = .automatic

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.definesPresentationContext = true
    }
    
    private func getUsers() {
        self.viewModel.getUsers(completion: { users in
            self.users = users
            
            DispatchQueue.main.async {
                self.tblUsers.reloadData()
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
        cell.configureViewCell(displayObject: data)
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
