//
//  MainViewModel.swift
//  PokeDex
//
//  Created by 김승희 on 8/5/24.
//

import UIKit
import RxSwift

class MainViewModel {
    private let disposeBag = DisposeBag()
    
    let pokemonSubject = BehaviorSubject(value: [PokemonDetail]())
    init() {
        fetchPokemon()
    }
    
    func fetchPokemon() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0") else {
            pokemonSubject.onError(NetworkError.invaildUrl)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (pokemonResponse: PokemonResponse) in
                let pokemonDetails = pokemonResponse.results.compactMap { self?.fetchPokemonDetail(from: $0.url) }
                
                Observable.zip(pokemonDetails)
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] details in
                        print("1번: \(details)")
                        self?.pokemonSubject.onNext(details)},
                    onError: { error in
                        print("2번: 에러")
                        self?.pokemonSubject.onError(error)
                    }).disposed(by: self?.disposeBag ?? DisposeBag())
                
            }, onFailure: { [weak self] error in
                self?.pokemonSubject.onError(error)
            }).disposed(by: disposeBag)
    }
    
    func fetchPokemonDetail(from urlString: String?) -> Observable<PokemonDetail> {
        guard let urlString = urlString,
              let pokemonID = urlString.split(separator: "/").last,
              let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonID)/") else {
            return Observable.error(NetworkError.invaildUrl)
        }
        return NetworkManager.shared.fetch(url: url).asObservable()
    }
}

