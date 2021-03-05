//
//  TWKViewController.swift
//  Github-Users
//
//  Created by William S. Rena on 2/25/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

class TWKViewController: UIViewController, WSRKeyboardObserverProtocol {
    var activeTextInput: UITextInput?
    
    let refreshControl = UIRefreshControl()
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateOfflineIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateOfflineIndicator()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Private Methods
    
    
    // MARK: - Public Methods
    
    public func updateOfflineIndicator() {
        let titleColor = TWKNetworkManager.shared.isConnectedToNetwork() ? UIColor.black : UIColor.orange
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: titleColor]
    }
    
    func enableRefreshControl(tableView: UITableView) {
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        }
        else {
            tableView.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        let color = UIColor.red
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        self.refreshControl.tintColor = color
        self.refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data ...", attributes: attributes)
    }

    // MARK: - Handlers
    
    @objc func refreshData(_ sender: Any) {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 3,
            execute: {
                self.refreshControl.endRefreshing()
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

