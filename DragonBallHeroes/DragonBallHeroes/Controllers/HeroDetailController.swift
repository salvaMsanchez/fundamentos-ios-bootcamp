//
//  HeroDetailController.swift
//  DragonBallHeroes
//
//  Created by Salva Moreno.
//

import Foundation
import UIKit

final class HeroDetailController: UIViewController {
    
    var hero: Hero?
    var hasTransformation: Bool?
    var transformations: [Transformation]?
    
    override func loadView() {
        super.loadView()
        
        let heroDetailView = HeroDetailView()
        if let hero {
            heroDetailView.configureView(heroData: hero)
        }
        if let hasTransformation {
            if hasTransformation {
                heroDetailView.addTransformationsButton()
            }
        }
        self.view = heroDetailView
        
        // Captación de la pulsación del botón en condiciones adecuadas para realizar navegación
        if let heroDetailView = self.view as? HeroDetailView,
        let transformations {
            heroDetailView.transformationsButtonTapHandler = { [weak self] in
                self?.goToTransformationsListController(transformations: transformations)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = hero?.name
    }
    
    func goToTransformationsListController(transformations: [Transformation]) {
        // Crear una instancia del ViewController de destino
        let transformationsListController = TransformationsListController()
        transformationsListController.heroData = transformations
        // Realizar la navegación al ViewController de destino
        navigationController?.pushViewController(transformationsListController, animated: true)
    }
    
}
