//
//  ViewController.swift
//  PokeDex
//
//  Created by 김승희 on 8/5/24.
//

import UIKit
import RxSwift
import SnapKit

class MainViewController: UIViewController {
    
    private let mainViewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    private var pokemonDetail = [PokemonDetail]()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pokemonBall")
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(PokedexCell.self, forCellWithReuseIdentifier: PokedexCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .darkRed
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        bind()
    }
    
    func bind() {
        // 포켓몬 목록을 구독하여 업데이트
        mainViewModel.pokemonSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pokemonList in
                guard let self = self else { return }
                print("Pokemon List Updated: \(pokemonList)")
                self.collectionView.reloadData() // 포켓몬 목록이 업데이트되면 컬렉션 뷰를 리로드
            }, onError: { error in
                print("Error occurred: \(error)")
            }).disposed(by: disposeBag)
        
        // 이미지 데이터를 구독하여 업데이트
        mainViewModel.pokemonImageSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadData() // 이미지가 업데이트되면 컬렉션 뷰를 리로드
            }, onError: { error in
                print("Error occurred: \(error)")
            }).disposed(by: disposeBag)
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configUI() {
        view.backgroundColor = .mainRed
        [imageView, collectionView].forEach { view.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(40)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        if offsetY > contentHeight - frameHeight - 500 {
            mainViewModel.fetchPokemon()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPokemonDetail = pokemonDetail[indexPath.item]
        navigationController?.pushViewController(DetailViewController(pokemonDetail: selectedPokemonDetail), animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = (try? mainViewModel.pokemonSubject.value().count) ?? 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokedexCell.id, for: indexPath) as? PokedexCell else {
            return UICollectionViewCell()
        }
        let pokemon = try? mainViewModel.pokemonSubject.value()[indexPath.item]
        let image = try? mainViewModel.pokemonImageSubject.value()[indexPath.row + 1]
        cell.configure(with: pokemon, image: image)
        
        return cell
    }
}

