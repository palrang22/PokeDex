//
//  DetailViewController.swift
//  PokeDex
//
//  Created by 김승희 on 8/7/24.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    private var pokemonDetail: PokemonDetail
    
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .darkRed
        containerView.layer.cornerRadius = 10
        return containerView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let noLabel: UILabel = {
        let label = UILabel()
        label.text = "11"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 26)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "11"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 26)
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "11"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "11"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "11"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [noLabel, nameLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    init(pokemonDetail: PokemonDetail) {
        self.pokemonDetail = pokemonDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    private func updateUI() {
        imageView.loadPokemonImg(for: pokemonDetail)
        noLabel.text = "No.\(pokemonDetail.id ?? 0)"
        nameLabel.text = "\(PokemonNameTranslate.getKoreanName(for: pokemonDetail.name ?? ""))"
        typeLabel.text = "타입: \(PokemonTypeTranslate.getKoreanType(for:pokemonDetail.types?.first?.type.name ?? ""))"
        heightLabel.text = "키: \(pokemonDetail.height ?? 0)m"
        weightLabel.text = "몸무게: \(pokemonDetail.weight ?? 0)kg"
    }
    
    private func setupUI() {
        [imageView, stackView, typeLabel, heightLabel, weightLabel].forEach { containerView.addSubview($0) }
        view.addSubview(containerView)
        view.backgroundColor = .mainRed
        
        containerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges).inset(30)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.height.equalTo(500)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.height.width.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        heightLabel.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        weightLabel.snp.makeConstraints {
            $0.top.equalTo(heightLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
}
