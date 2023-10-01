//
//  Protocols.swift
//  DragonBallHeroes
//
//  Created by Salva Moreno.
//

import Foundation

protocol MainHeroData: Decodable {
    var id: String { get }
    var name: String { get }
    var description: String { get }
    var photo: URL { get }
}

protocol ListViewControllerProtocol: AnyObject {
    var heroData: [MainHeroData]? { get }
}
