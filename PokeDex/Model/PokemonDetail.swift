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
    let types: [Types]?
    let height: Int?
    let weight: Int?
}

struct Types: Codable {
    let type: TypeInfo
}

struct TypeInfo: Codable {
    let name: String
}
