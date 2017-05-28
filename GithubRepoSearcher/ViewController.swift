//
//  ViewController.swift
//  GithubRepoSearcher
//
//  Created by Yuki Yoshioka on 2017/05/28.
//  Copyright © 2017年 rikusouda. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var searchButton: NSButton!
    @IBOutlet var searchWordsTextView: NSTextView!
    @IBOutlet var searchResultTextView: NSTextView!
    @IBOutlet weak var repoName: NSTextField!

    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func didClickSearch(_ sender: Any) {
        guard let searchWords = searchWordsTextView.string else { return }
        let repoName = self.repoName.stringValue
        
        let words = searchWords.components(separatedBy: .whitespacesAndNewlines)
        searchResultTextView.string = ""
        
        var doSearch: (([String], Int) -> Void)!
        doSearch = { (words, current) in
            let word = words[current]
            GithubCodeSearch.search(repo: repoName, word: word)
                .observeOn(MainScheduler.instance)
                .subscribe { [unowned self] in
                    switch $0 {
                    case let .next(result):
                        if let result = result {
                            self.searchResultTextView.string =
                                self.searchResultTextView.string! + "\(result.totalCount)\t\(word)\n"
                        } else {
                            self.searchResultTextView.string =
                                self.searchResultTextView.string! + "no result\n"
                        }
                    case .error(_):
                        self.searchResultTextView.string =
                            self.searchResultTextView.string! + "error\n"
                    case .completed:
                        let next = current + 1
                        if next < words.count {
                            DispatchQueue.global().async {
                                sleep(6)    // GitHubのAPI制限を超えないようにするため少し待つ
                                doSearch(words, next)
                            }
                        } else {
                            self.searchResultTextView.string =
                                self.searchResultTextView.string! + "### Search has done! ###\n"
                        }
                    }
                }
                .addDisposableTo(self.disposeBag)
        }

        doSearch(words, 0)
    }
}

