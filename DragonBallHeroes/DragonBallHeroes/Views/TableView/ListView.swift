//
//  HeroesListView.swift
//  DragonBallHeroes
//
//  Created by Salva Moreno.
//

import Foundation
import UIKit

final class ListView: UIView {
    
    private let heroesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var getHeroesTableView: UITableView {
        return heroesTableView
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubviews()
        configureConstraints()
    }
    
    private func addSubviews() {
        [heroesTableView].forEach(addSubview)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            heroesTableView.topAnchor.constraint(equalTo: topAnchor),
            heroesTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            heroesTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            heroesTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
