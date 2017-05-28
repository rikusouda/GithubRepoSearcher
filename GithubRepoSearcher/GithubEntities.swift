//
//  GithubEntities.swift
//  GithubRepoSearcher
//
//  Created by Yuki Yoshioka on 2017/05/28.
//  Copyright © 2017年 rikusouda. All rights reserved.
//

import Foundation

struct SearchResult {
    let hitRepos: [GithubHitRepo]
    let totalCount: Int
    
    init?(response: Any) {
        guard let response = response as? [String : Any],
            let hitReposDictionaries = response["items"] as? [[String : Any]],
            let count = response["total_count"] as? Int
            else { return nil }
        
        hitRepos = hitReposDictionaries.flatMap { GithubHitRepo(dictionary: $0) }
        totalCount = count
    }
}

struct GithubHitRepo {
    let name: String
    let path: String
    let htmlURL: String
    
    let repo: GithubRepository
    
    init(dictionary: [String: Any]) {
        name = dictionary["name"] as! String
        path = dictionary["path"] as! String
        htmlURL = dictionary["html_url"] as! String
        repo = GithubRepository(dictionary: dictionary["repository"] as! [String: Any])
    }
}

struct GithubRepository {
    let name: String
    init(dictionary: [String : Any]) {
        name = dictionary["full_name"] as! String
    }
}
