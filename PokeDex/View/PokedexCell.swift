//
//  PokedexCell.swift
//  PokeDex
//
//  Created by 김승희 on 8/5/24.
//

import UIKit

class PokedexCell: UICollectionViewCell {
    static let id = "PokedexCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .cellBackground
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setCell() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with pokemon: Pokemon?, image: UIImage?) {
        imageView.image = image ?? UIImage(named: "pokemonBallLoading")
    }
}
