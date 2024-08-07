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
    private let limit = 20
    private var offset = 0
    private var isFetching = false
    
    let pokemonSubject = BehaviorSubject(value: [PokemonDetail]())
    
    init() {
        fetchPokemon()
    }
    
    func fetchPokemon() {
        guard !isFetching else { return }
        isFetching = true
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            pokemonSubject.onError(NetworkError.invalidUrl)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .flatMap { [weak self] (pokemonResponse : PokemonResponse) -> Single<[PokemonDetail]> in
                guard let self else { return Single.just([]) }
                let pokemonDetail = pokemonResponse.results.compactMap { self.fetchPokemonDetail(from:$0.url).asSingle()}
                return Single.zip(pokemonDetail)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] details in
                guard let self else { return }
                var currentDetails = try? self.pokemonSubject.value()
                currentDetails?.append(contentsOf: details)
                self.pokemonSubject.onNext(currentDetails ?? [])
                self.offset += self.limit
                self.isFetching = false
            }, onFailure: { error in
                self.pokemonSubject.onError(error)
                self.isFetching = false
            }).disposed(by: self.disposeBag)
    }
    
    func fetchPokemonDetail(from urlString: String?) -> Observable<PokemonDetail> {
        guard let urlString = urlString,
              let pokemonID = urlString.split(separator: "/").last,
              let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonID)/") else {
            return Observable.error(NetworkError.invalidUrl)
        }
        return NetworkManager.shared.fetch(url: url).asObservable()
    }
}

