//
//  Hero.swift
//  DragonBallHeroes
//
//  Created by Salva Moreno.
//

import Foundation

struct Hero: MainHeroData, Equatable {
    let id: String
    let name: String
    let description: String
    let photo: URL
    let favorite: Bool
}
