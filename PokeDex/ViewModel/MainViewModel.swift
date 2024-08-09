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
    
    let pokemonSubject = BehaviorSubject(value: [Pokemon]())
    let pokemonImageSubject = BehaviorSubject<[Int: UIImage]>(value: [:])
    //let pokemonSubject = BehaviorSubject(value: [PokemonDetail]())
    
    init() {
        fetchPokemon()
    }
    
    func fetchPokemon() {
        guard !isFetching else { return }
        isFetching = true
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            pokemonSubject.onError(NetworkError.invalidUrl)
            isFetching = false
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (pokemonResponse: PokemonResponse) in
                guard let self = self else { return }
                var currentPokemon = (try? self.pokemonSubject.value()) ?? []
                currentPokemon.append(contentsOf: pokemonResponse.results)
                self.pokemonSubject.onNext(currentPokemon)
                self.fetchPokemonImages(for: pokemonResponse.results)
                self.offset += self.limit
                self.isFetching = false
            }, onFailure: { [weak self] error in
                self?.pokemonSubject.onError(error)
                self?.isFetching = false
            }).disposed(by: disposeBag)
    }
        
    private func fetchPokemonImages(for pokemonList: [Pokemon]) {
        let imageRequests = pokemonList.compactMap { pokemon -> Single<(Int, UIImage)> in
            guard let id = pokemon.url!.split(separator: "/").last, let pokemonID = Int(id) else {
                return Single.error(NetworkError.invalidUrl)
            }
            let imageUrlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemonID).png"
            guard let imageUrl = URL(string: imageUrlString) else {
                return Single.error(NetworkError.invalidUrl)
            }
            return NetworkManager.shared.fetchImage(url: imageUrl)
                .map { image in (pokemonID, image) }
        }
        
        Single.zip(imageRequests)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] images in
                guard let self = self else { return }
                var currentImages = (try? self.pokemonImageSubject.value()) ?? [:]
                for (id, image) in images {
                    currentImages[id] = image
                }
                self.pokemonImageSubject.onNext(currentImages)
            }, onFailure: { error in
                print("에러 발생: \(error)")
            }).disposed(by: disposeBag)
    }
}

