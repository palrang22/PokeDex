//
//  PokemonDetail.swift
//  PokeDex
//
//  Created by 김승희 on 8/7/24.
//

import Foundation

struct PokemonDetail: Codable {
    let id: Int?
    let name: String?
    let types: String?
    let height: Int?
    let weight: Int?
}
