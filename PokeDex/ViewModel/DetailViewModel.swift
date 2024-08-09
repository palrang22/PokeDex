//
//  DetailViewModel.swift
//  PokeDex
//
//  Created by 김승희 on 8/9/24.
//

import UIKit
import RxSwift

class DetailViewModel {
    private let disposeBag = DisposeBag()
    let pokemonDetailSubject = BehaviorSubject<PokemonDetail?>(value: nil)
        
    func fetchPokemonDetail(from urlString: String?) {
        guard let urlString = urlString,
              let pokemonID = urlString.split(separator: "/").last,
              let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonID)/") else {
            pokemonDetailSubject.onError(NetworkError.invalidUrl)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] pokemonDetail in
                self?.pokemonDetailSubject.onNext(pokemonDetail)
            }, onFailure: { [weak self] error in
                self?.pokemonDetailSubject.onError(error)
            }).disposed(by: disposeBag)
    }
}
