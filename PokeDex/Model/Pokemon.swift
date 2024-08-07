//
//  Pokemon.swift
//  PokeDex
//
//  Created by 김승희 on 8/5/24.
//

import Foundation

struct PokemonResponse: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let url: String?
}
