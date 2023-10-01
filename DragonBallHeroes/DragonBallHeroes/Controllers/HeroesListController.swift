//
//  HeroesListController.swift
//  DragonBallHeroes
//
//  Created by Salva Moreno.
//

import Foundation
import UIKit
import SafariServices

final class HeroesListController: UIViewController, ListViewControllerProtocol {
    
    var heroData: [MainHeroData]?
    private let apiClient: APIClient = APIClient()
    
    // MARK: - Delegates
    private var dataSource: ListTableViewDataSource<Hero>?
    private var delegate: ListTableViewDelegate<Hero>?
    
    override func loadView() {
        super.loadView()
        self.view = ListView()

        // MARK: - DataSourceDelegate
        if let heroesListView = view.self as? ListView {
            if let heroData = heroData as? [Hero] {
                self.dataSource = ListTableViewDataSource(dataSource: heroData)
            } else {
                self.dataSource = ListTableViewDataSource(dataSource: [])
            }
            heroesListView.getHeroesTableView.dataSource = dataSource
            heroesListView.getHeroesTableView.register(ListTableViewCustomCell.self, forCellReuseIdentifier: "ListTableViewCustomCell")
        }

        // MARK: - UITableViewDelegate
        if let heroesListView = view.self as? ListView {
            self.delegate = ListTableViewDelegate()
            self.delegate?.viewController = self // Adjudicación del propio ViewController a la variable del delegate
            heroesListView.getHeroesTableView.delegate = delegate
            
            delegate?.cellTapHandler = { [weak self] hero in
                self?.goToHeroDetailController(hero: hero)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        title = "Héroes"
        
        // BAR BUTTONS
        let info = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(infoButtonTapped))
        let logOut = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(dismissSession))
        navigationItem.rightBarButtonItems = [logOut, info]
        
        // Suscripción a la notificación
        NotificationCenter.default.addObserver(self, selector: #selector(handleHeroesDataUpdated), name: NSNotification.Name("HeroesDataUpdated"), object: nil)
    }
    
    func goToHeroDetailController(hero: Hero) {
        // Llamada a la API para obtener transformaciones y saber si tiene o no
        apiClient.getTransformations(for: hero) { [weak self] result in
            switch result {
                case let .success(transformations):
                    DispatchQueue.main.async {
                        // Crear una instancia del ViewController de destino
                        let heroDetailController = HeroDetailController()
                        heroDetailController.hasTransformation = transformations.isEmpty ? false : true
                        // Configurar el ViewController de destino con la información que deseas pasar
                        let transformationsSorted = self?.sortTransformations(heroData: transformations)
                        heroDetailController.transformations = transformationsSorted
                        heroDetailController.hero = hero
                        // Realizar la navegación al ViewController de destino
                        self?.navigationController?.pushViewController(heroDetailController, animated: true)
                    }
                case let .failure(error):
                    print("Error: \(error)")
            }
        }
    }
    
    @objc
    func infoButtonTapped() {
        guard let url = URL(string: "https://es.wikipedia.org/wiki/Dragon_Ball") else {
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }
    
    @objc
    func dismissSession() {
        dismiss(animated: true)
    }
    
    // NOTIFICATION METHOD
    @objc
    func handleHeroesDataUpdated() {
        // Actualiza el dataSource y recarga la tabla con los nuevos datos
        DispatchQueue.main.async { [weak self] in
            if let heroesListView = self?.view as? ListView {
                if let heroData = self?.heroData as? [Hero] {
                    // Actualización DataSource
                    self?.dataSource = ListTableViewDataSource(dataSource: heroData)
                    heroesListView.getHeroesTableView.dataSource = self?.dataSource
                    heroesListView.getHeroesTableView.reloadData()
                    
                    // Actualización Delegate
                    self?.delegate = ListTableViewDelegate()
                    self?.delegate?.viewController = self
                    heroesListView.getHeroesTableView.delegate = self?.delegate
                                    
                    self?.delegate?.cellTapHandler = { [weak self] hero in
                        self?.goToHeroDetailController(hero: hero)
                    }
                }
            }
        }
        
    }
    
    deinit {
        // Desuscripción de la notificación cuando el ViewController se destruya
        NotificationCenter.default.removeObserver(self)
    }
    
    func sortTransformations(heroData: [MainHeroData]) -> [Transformation] {
        if var transformations = heroData as? [Transformation] {
            transformations = transformations.sorted { element1, element2 in
                if let number1 = Int(element1.name.components(separatedBy: ".").first ?? ""),
                   let number2 = Int(element2.name.components(separatedBy: ".").first ?? "") {
                    return number1 < number2
                }
                return false
            }
            return transformations
        } else {
            return []
        }
    }
    
}
