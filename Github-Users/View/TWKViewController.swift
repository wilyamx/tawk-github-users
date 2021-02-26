//
//  TWKViewController.swift
//  Github-Users
//
//  Created by William S. Rena on 2/25/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

class TWKViewController: UIViewController {

    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Public Methods
    
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
    
    @objc private func refreshData(_ sender: Any) {
        print("fetch-data...")
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
