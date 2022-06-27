//
//  DetailsView.swift
//  PataTest
//
//  Created by Franco on 27/06/22.
//

import PataCore
import UIKit

final class DetailsView: UIView {
    struct ViewModel {
        let image: PataImage?
        let title: String
        let artist: String
        let extraDetails: [String]?
    }
    
    enum Action {
        case attemptToSeeMore
    }
    
    var viewModel: ViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    var actionHandler: ((Action) -> Void) = { _ in }
    
    private let artImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See More", for: .normal)
        button.addTarget(self, action: #selector(didTapSeeMore), for: .touchUpInside)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setSubviews() {
        backgroundColor = .systemGray
        addSubview(artImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            artImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            artImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            artImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            artImageView.heightAnchor.constraint(equalToConstant: 500),
            
            titleLabel.topAnchor.constraint(equalTo: artImageView.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.artist
        
        if let image = viewModel.image {
            artImageView.setPataImage(image)
        }
    }
    
    @objc
    private func didTapSeeMore() {
        actionHandler(.attemptToSeeMore)
    }
}

