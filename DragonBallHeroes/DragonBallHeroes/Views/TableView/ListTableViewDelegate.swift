//
//  HeroesListTableViewDelegate.swift
//  DragonBallHeroes
//
//  Created by Salva Moreno.
//

import Foundation
import UIKit

final class ListTableViewDelegate<T: MainHeroData>: NSObject, UITableViewDelegate {
    
    // Conexión con ViewController
    weak var viewController: ListViewControllerProtocol?
    
    // Closure/callback de envío de información al ViewController cuando se pulsa una celda
    var cellTapHandler: ((T) -> Void)?
    
    // Método para saber qué celda se está pulsando
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let heroData = viewController?.heroData {
            let model = heroData[indexPath.row]
            if let model = model as? T {
                cellTapHandler?(model)
            }
        }
        
        // Deseleccionar la celda
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
