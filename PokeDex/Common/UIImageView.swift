//
//  UIImageView.swift
//  PokeDex
//
//  Created by 김승희 on 8/7/24.
//

import UIKit

extension UIImageView {
    func loadPokemonImg(for pokemonDetail: PokemonDetail) {
        guard let id = pokemonDetail.id else { return }
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
