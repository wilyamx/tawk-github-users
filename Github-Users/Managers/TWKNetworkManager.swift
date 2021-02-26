//
//  TWKNetworkManager.swift
//  Github-Users
//
//  Created by William S. Rena on 2/26/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import Foundation

struct TWKRequestError {
    var errorCode: Int = 0
    var errorMessage: String = ""
}

enum TWKResponse<T> {
    case succeed(T)
    case failed(TWKRequestError)
}

class TWKNetworkManager {
    static let shared = TWKNetworkManager()
    
    static let BASE_URL = "https://api.github.com"
    static let PAGE_SIZE = 5
    
    // MARK: - Public Methods
    
    /*
     [
       {
         "login": "octocat",
         "id": 1,
         "node_id": "MDQ6VXNlcjE=",
         "avatar_url": "https://github.com/images/error/octocat_happy.gif",
         "gravatar_id": "",
         "url": "https://api.github.com/users/octocat",
         "html_url": "https://github.com/octocat",
         "followers_url": "https://api.github.com/users/octocat/followers",
         "following_url": "https://api.github.com/users/octocat/following{/other_user}",
         "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
         "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
         "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
         "organizations_url": "https://api.github.com/users/octocat/orgs",
         "repos_url": "https://api.github.com/users/octocat/repos",
         "events_url": "https://api.github.com/users/octocat/events{/privacy}",
         "received_events_url": "https://api.github.com/users/octocat/received_events",
         "type": "User",
         "site_admin": false
       }
     ]
     */
    public func getUsers(
        lastUserId: Int32,
        completion: @escaping ([TWKGithubUserCodable]?) -> ()) {
        
        guard let url = URL(string: "\(TWKNetworkManager.BASE_URL)/users?since=\(lastUserId)&per_page=\(TWKNetworkManager.PAGE_SIZE)") else {
            return
        }
        
        URLSession.shared.dataTask(
            with: url,
            completionHandler: {
                data, response, error -> Void in
                    if let data = data {
                        do {
                            let jsonDecoder = JSONDecoder()
                            let responseModel = try jsonDecoder.decode([TWKGithubUserCodable].self, from: data)
                            DebugInfoKey.api.log(info: "\(responseModel)")
                            completion(responseModel)
                        }
                        catch let error {
                            DebugInfoKey.error.log(info: "JSON Serialization error :: \(error)")
                        }
                    }
            }).resume()
        
    }
    
    /*
     {
       "login": "github",
       "id": 1,
       "node_id": "MDEyOk9yZ2FuaXphdGlvbjE=",
       "url": "https://api.github.com/orgs/github",
       "repos_url": "https://api.github.com/orgs/github/repos",
       "events_url": "https://api.github.com/orgs/github/events",
       "hooks_url": "https://api.github.com/orgs/github/hooks",
       "issues_url": "https://api.github.com/orgs/github/issues",
       "members_url": "https://api.github.com/orgs/github/members{/member}",
       "public_members_url": "https://api.github.com/orgs/github/public_members{/member}",
       "avatar_url": "https://github.com/images/error/octocat_happy.gif",
       "description": "A great organization",
       "name": "github",
       "company": "GitHub",
       "blog": "https://github.com/blog",
       "location": "San Francisco",
       "email": "octocat@github.com",
       "twitter_username": "github",
       "is_verified": true,
       "has_organization_projects": true,
       "has_repository_projects": true,
       "public_repos": 2,
       "public_gists": 1,
       "followers": 20,
       "following": 0,
       "html_url": "https://github.com/octocat",
       "created_at": "2008-01-14T04:33:35Z",
       "updated_at": "2014-03-03T18:58:10Z",
       "type": "Organization",
       "total_private_repos": 100,
       "owned_private_repos": 100,
       "private_gists": 81,
       "disk_usage": 10000,
       "collaborators": 8,
       "billing_email": "mona@github.com",
       "plan": {
         "name": "Medium",
         "space": 400,
         "private_repos": 20
       },
       "default_repository_permission": "read",
       "members_can_create_repositories": true,
       "two_factor_requirement_enabled": true,
       "members_allowed_repository_creation_type": "all",
       "members_can_create_public_repositories": false,
       "members_can_create_private_repositories": false,
       "members_can_create_internal_repositories": false,
       "members_can_create_pages": true
     }
     */
    public func getOrganizationDetails(
        organizationsUrl: String,
        completion: @escaping (TWKGithubOrganizationCodable?) -> ()) {
        
        //FIXME: invalid url and parameter used
        guard let url = URL(string: "\(organizationsUrl)/org?org=\(organizationsUrl)") else {
            return
        }
//        guard let url = URL(string: "\(organizationsUrl)?org=\(organizationsUrl)") else {
//            return
//        }
        
        URLSession.shared.dataTask(
            with: url,
            completionHandler: {
                data, response, error -> Void in
                    if let data = data {
                        do {
                            let jsonDecoder = JSONDecoder()
                            let responseModel = try jsonDecoder.decode(TWKGithubOrganizationCodable.self, from: data)
                            DebugInfoKey.api.log(info: "\(responseModel)")
                            completion(responseModel)
                        }
                        catch let error {
                            DebugInfoKey.error.log(info: "JSON Serialization error :: \(error)")
                        }
                    }
            }).resume()
        
    }
}
