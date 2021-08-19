//
//  GitHubAPI.swift
//  MVP-GitHubSearch
//
//  Created by Yudai Fujioka on 2021/08/18.
//

import Foundation

enum GitHubError: Error {
    case error, connect, parse
}

struct GitHubParameters {
    let searchWord: String?
    private var _searchWord: String { searchWord ?? "" }
    
    var queryParameter: String {
        "q=\(_searchWord)"
    }
}

protocol GitHubAPIProtocol {
    func getItems(parameter: GitHubParameters, completion: ((Result<[GitHubModel], Error>) -> Void)?)
}

final class GitHubAPI: GitHubAPIProtocol {
    static let shared = GitHubAPI()
    
    private init() {}
    
    func getItems(parameter: GitHubParameters, completion: ((Result<[GitHubModel], Error>) -> Void)?) {
        let url = URL(string: "https://api.github.com/search/repositories?\(parameter.queryParameter)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let responseData = try? JSONDecoder().decode(GitHubResponse.self, from: data),
                  let model = responseData.items
            else {
                completion?(.failure(GitHubError.error))
                return
            }
            completion?(.success(model))
        }
        task.resume()
    }
}
