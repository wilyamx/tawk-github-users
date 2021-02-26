//
//  TWKUserDetailsViewModel.swift
//  Github-Users
//
//  Created by William S. Rena on 2/26/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

class TWKUserDetailsViewModel: TWKViewModel {
    
    func getOrganizationDetails(
        organizationsUrl: String,
        completion: @escaping (TWKOrganizationDO) -> () ) {
        
        TWKNetworkManager.shared.getOrganizationDetails(
            organizationsUrl: organizationsUrl,
            completion: { organization in
                // convert codable data to display model
                if let organization = organization {
                    completion(TWKOrganizationDO(followers: organization.followers ?? 0,
                                                 following: organization.following ?? 0))
                }
            })
    }
}
