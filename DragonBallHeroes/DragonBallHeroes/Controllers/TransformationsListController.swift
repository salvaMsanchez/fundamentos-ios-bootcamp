//
//  TransformationsListController.swift
//  DragonBallHeroes
//
//  Created by Salva Moreno.
//

import Foundation
import UIKit

final class TransformationsListController: UIViewController, ListViewControllerProtocol {
    
    var heroData: [MainHeroData]?
    
    // MARK: - Delegates
    private var dataSource: ListTableViewDataSource<Transformation>?
    private var delegate: ListTableViewDelegate<Transformation>?
    
    override func loadView() {
        super.loadView()
        self.view = ListView()
        
        // MARK: - DataSourceDelegate
        if let heroesListView = view.self as? ListView {
            if let heroData = heroData as? [Transformation] {
                self.dataSource = ListTableViewDataSource(dataSource: heroData)
            } else {
                self.dataSource = ListTableViewDataSource(dataSource: [])
            }
            heroesListView.getHeroesTableView.dataSource = dataSource
            heroesListView.getHeroesTableView.register(ListTableViewCustomCell.self, forCellReuseIdentifier: "ListTableViewCustomCell")
        }
        
        // MARK: - UITableViewDelegate
        if let heroesListView = view.self as? ListView {
            self.delegate = ListTableViewDelegate<Transformation>()
            self.delegate?.viewController = self // Adjudicación del propio ViewController a la variable del delegate
            heroesListView.getHeroesTableView.delegate = delegate
            
            delegate?.cellTapHandler = { [weak self] transformation in
                self?.goToTransformationDetailController(transformation: transformation)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transformaciones"
        
    }
    
    func goToTransformationDetailController(transformation: Transformation) {
        let transformationDetailController = TransformationDetailController()
        transformationDetailController.transformation = transformation
        navigationController?.pushViewController(transformationDetailController, animated: true)
    }
    
}
