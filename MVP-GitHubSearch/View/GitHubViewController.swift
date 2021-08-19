//
//  GitHubViewController.swift
//  MVP-GitHubSearch
//
//  Created by Yudai Fujioka on 2021/08/18.
//

import UIKit

final class GitHubViewController: UIViewController {

    private let cellId = "cellId"
    
    private var presenterInput: GitHubSearchPresenterInput!
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(GitHubTableViewCell.self, forCellReuseIdentifier: cellId)
        }
    }
    
    @IBOutlet private weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        let presenter = GitHubSearchPresenter(output: self)
        inject(presenter: presenter)
        
    }
    
    private func inject(presenter: GitHubSearchPresenterInput) {
        self.presenterInput = presenter
    }
}

//Presenterから送られてきた通知から何をするか
extension GitHubViewController: GitHubSearchPresenterOutput {
    func update(gitHubModel: [GitHubModel]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension GitHubViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension GitHubViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenterInput.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GitHubTableViewCell
        let gitHubModel = presenterInput.item(index: indexPath.item)
        cell.configure(githubModel: gitHubModel)
        return cell
    }
}

extension GitHubViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //パラメータ（検索するワード）を渡して、何をするかはPresenterに任せる
        let parameter = GitHubParameters.init(searchWord: searchBar.text)
        self.presenterInput.search(parameter: parameter)
    }
}

