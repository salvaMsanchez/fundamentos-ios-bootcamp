//
//  TransformationDetailController.swift
//  DragonBallHeroes
//
//  Created by Salva Moreno.
//

import Foundation
import UIKit

final class TransformationDetailController: UIViewController {
    
    var transformation: Transformation?
    
    override func loadView() {
        super.loadView()
        let transformationDetailView = HeroDetailView()
        if let transformation {
            transformationDetailView.configureView(heroData: transformation)
        }
        self.view = transformationDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        if let transformation {
            title = transformation.name.components(separatedBy: ".").last
        } else {
            title = ""
        }
    }
    
}
