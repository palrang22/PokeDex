//
//  DetailViewController.swift
//  PokeDex
//
//  Created by 김승희 on 8/7/24.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    private let id: Int
    
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .darkRed
        containerView.layer.cornerRadius = 10
        return containerView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let noLabel: UILabel = {
        let label = UILabel()
        label.text = "11"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "11"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "11"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "11"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "11"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
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
    
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        [imageView, stackView, typeLabel, heightLabel, weightLabel].forEach { containerView.addSubview($0) }
        view.addSubview(containerView)
        view.backgroundColor = .mainRed
        
        containerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges).inset(30)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.height.equalTo(400)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
        }
        
        heightLabel.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(20)
        }
        
        weightLabel.snp.makeConstraints {
            $0.top.equalTo(heightLabel.snp.bottom).offset(20)
        }
    }
    

}
