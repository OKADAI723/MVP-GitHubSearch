//
//  GitHubSearchPresenter.swift
//  MVP-GitHubSearch
//
//  Created by Yudai Fujioka on 2021/08/18.
//

import Foundation

//入力に関するプロトコル
protocol GitHubSearchPresenterInput {
    var numberOfItems: Int { get }
    func item(index: Int) -> GitHubModel
    func search(parameter: GitHubParameters)
}

//出力に関するプロトコル
protocol GitHubSearchPresenterOutput: AnyObject {
    func update(gitHubModel: [GitHubModel])
}

final class GitHubSearchPresenter {
    private weak var output: GitHubSearchPresenterOutput!
    private var api: GitHubAPIProtocol!
   
    
    private var gitHubModel: [GitHubModel]
    
    
    init(output: GitHubSearchPresenterOutput, api: GitHubAPIProtocol = GitHubAPI.shared) {
        self.output = output
        self.api = api
        self.gitHubModel = []
    }
}

//PresenterはInputのプロトコルに準拠
extension GitHubSearchPresenter: GitHubSearchPresenterInput {
    
    var numberOfItems: Int {
        gitHubModel.count
    }
    
    func item(index: Int) -> GitHubModel {
        gitHubModel[index]
    }
    
    func search(parameter: GitHubParameters) {
        self.api.getItems(parameter: parameter) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let gitHubModel):
                self?.gitHubModel = gitHubModel
                self?.output.update(gitHubModel: gitHubModel)
            }
        }
    }
}
