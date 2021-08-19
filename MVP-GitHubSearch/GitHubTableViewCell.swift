//
//  GitHubTableViewCell.swift
//  MVP-GitHubSearch
//
//  Created by Yudai Fujioka on 2021/08/18.
//

import UIKit

final class GitHubTableViewCell: UITableViewCell {

    func configure(githubModel: GitHubModel) {
        self.textLabel?.text = githubModel.name
    }
}
