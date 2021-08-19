//
//  GitHubModel.swift
//  MVP-GitHubSearch
//
//  Created by Yudai Fujioka on 2021/08/18.
//

import Foundation

struct GitHubResponse: Codable {
    let items: [GitHubModel]?
}

struct GitHubModel: Codable {
    let name: String
    let id: Int
}
