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
    
    private let viewModel = MainViewModel()
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
        viewModel.pokemonSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] detail in
                print("bind: \(detail)")
                self?.pokemonDetail = detail
                self?.collectionView.reloadData()
            }, onError: { error in
                print("에러 발생: \(error)")
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
            viewModel.fetchPokemon()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPokemonDetail = pokemonDetail[indexPath.item]
        navigationController?.pushViewController(DetailViewController(pokemonDetail: selectedPokemonDetail), animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonDetail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokedexCell.id, for: indexPath) as? PokedexCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: pokemonDetail[indexPath.row])
        return cell
    }
}

