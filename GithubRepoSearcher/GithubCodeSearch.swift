//
//  GithubCodeSearch.swift
//  GithubRepoSearcher
//
//  Created by Yuki Yoshioka on 2017/05/28.
//  Copyright © 2017年 rikusouda. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct GithubCodeSearch {
    private init() {}
    
    static func search(repo: String, word: String) -> Observable<SearchResult?> {
        let endPoint = "https://api.github.com"
        let path = "/search/code"
        let query = "?q=\(word)+in:file+repo:\(repo)"
        let url = URL(string: endPoint + path + query)!
        let request = URLRequest(url: url)
        return URLSession.shared
            .rx.json(request: request)
            .map { SearchResult(response: $0) }
    }
}
