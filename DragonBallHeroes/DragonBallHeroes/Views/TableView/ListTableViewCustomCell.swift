//
//  HeroesListTableViewCustomCell.swift
//  DragonBallHeroes
//
//  Created by Salva Moreno.
//

import Foundation
import UIKit

final class ListTableViewCustomCell: UITableViewCell {
    
    private let heroCellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let heroTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let heroNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heroDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let whiteSpace: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [heroNameLabel, heroDescriptionLabel].forEach(heroTextStackView.addArrangedSubview)
        [heroImageView, heroTextStackView].forEach(heroCellStackView.addArrangedSubview)
        [heroCellStackView, whiteSpace, chevronImageView].forEach(addSubview)
        
        NSLayoutConstraint.activate([
            heroImageView.heightAnchor.constraint(equalToConstant: 100),
            heroImageView.widthAnchor.constraint(equalToConstant: 150),
            
            heroCellStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            heroCellStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            heroCellStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            whiteSpace.leadingAnchor.constraint(equalTo: heroCellStackView.trailingAnchor),
            whiteSpace.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            chevronImageView.leadingAnchor.constraint(equalTo: whiteSpace.trailingAnchor, constant: 12),
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(heroData: MainHeroData) {
        heroImageView.setImage(for: heroData.photo)
        heroNameLabel.text = heroData.name
        heroDescriptionLabel.text = heroData.description
    }
    
}
