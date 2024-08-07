//
//  MainViewModel.swift
//  PokeDex
//
//  Created by 김승희 on 8/5/24.
//

import UIKit
import RxSwift


//
// https://pokeapi.co/api/v2/pokemon/\(pokemon_id)/

class MainViewModel {
    private let disposeBag = DisposeBag()
    
    let pokemonSubject = BehaviorSubject(value: [Pokemon]())
    init() {}
    
    func fetchPokemon() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0") else {
            pokemonSubject.onError(NetworkError.invaildUrl)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (pokemonResponse: PokemonResponse) in
                self?.pokemonSubject.onNext(pokemonResponse.results)
            }, onFailure: { [weak self] error in
                self?.pokemonSubject.onError(error)
            }).disposed(by: disposeBag)
    }
}

