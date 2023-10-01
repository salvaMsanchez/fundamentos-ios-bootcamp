//
//  HeroDetailView.swift
//  DragonBallHeroes
//
//  Created by Salva Moreno.
//

import Foundation
import UIKit

final class HeroDetailView: UIView {
    
    private let heroDetailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let heroDetailTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let heroDetailNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heroDetailDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = .max
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var transformationsButtonTapHandler: (() -> Void)?
    
    private lazy var transformationsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Transformaciones", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20.0)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        [heroDetailNameLabel, heroDetailDescriptionLabel].forEach(heroDetailTextStackView.addArrangedSubview)
        [heroDetailImage, heroDetailTextStackView].forEach(addSubview)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            heroDetailImage.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            heroDetailImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            heroDetailImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            heroDetailImage.heightAnchor.constraint(equalToConstant: 200),
            
            heroDetailTextStackView.topAnchor.constraint(equalTo: heroDetailImage.bottomAnchor, constant: 16),
            heroDetailTextStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            heroDetailTextStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
    }
    
    @objc
    func buttonTouchDown() {
        zoomIn()
    }
    
    @objc
    func buttonTapped() {
        zoomOut()
        transformationsButtonTapHandler?()
    }
    
    func configureView(heroData: MainHeroData) {
        heroDetailImage.setImage(for: heroData.photo)
        heroDetailDescriptionLabel.text = heroData.description
        
        let heroName = heroData.name.components(separatedBy: ".")
        if heroName.count == 1 {
            heroDetailNameLabel.text = heroData.name
        } else {
            if (Int(heroName[0]) != nil) {
                let heroNameSplit = heroName.last?.components(separatedBy: " ")
                var heroNameCompleted = ""
                if let heroNameSplit {
                    for index in 1...heroNameSplit.count - 1 {
                        heroNameCompleted = heroNameCompleted + heroNameSplit[index] + " "
                    }
                }
                heroDetailNameLabel.text = heroNameCompleted
            } else {
                heroDetailNameLabel.text = heroData.name
            }
        }
    }
    
    func addTransformationsButton() {
        [transformationsButton].forEach(addSubview)
        NSLayoutConstraint.activate([
            transformationsButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -12),
            transformationsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            transformationsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            transformationsButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
}

// MARK: - Animations

extension HeroDetailView {
    func zoomIn() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0.5
        ) { [weak self] in
            self?.transformationsButton.transform = .identity.scaledBy(x: 0.94, y: 0.94)
        }
    }

    func zoomOut() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 2
        ) { [weak self] in
            self?.transformationsButton.transform = .identity
        }
    }

}
