//
//  HeroesListTableViewDataSource.swift
//  DragonBallHeroes
//
//  Created by Salva Moreno.
//

import Foundation
import UIKit

final class ListTableViewDataSource<T: MainHeroData>: NSObject, UITableViewDataSource {
    
    private let dataSource: [T]
    
    init(dataSource: [T]) {
        self.dataSource = dataSource
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ListTableViewCustomCell",
            for: indexPath) as? ListTableViewCustomCell else {
            return UITableViewCell()
        }
        // Accedemos uno a uno a nuestro modelo gracias al indexPath.row
        let heroData = dataSource[indexPath.row]
        // Adjudicamos a nuestra celda personalizada los datos del modelo
        cell.configure(heroData: heroData)
        
        return cell
    }
    
}
