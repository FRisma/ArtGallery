//
//  LastViewedView.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import PataCore
import UIKit

final class LastSeenCardView: UIView {
    struct ViewModel {
        let title: String
        let artist: String
        let thumbnail: PataImage?
    }
    
    var viewModel: ViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
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
        addSubview(titleLabel)
        addSubview(artistLabel)
        addSubview(thumbnailImageView)
        
        thumbnailImageView.layer.cornerRadius = .imageSideSize/2
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: .imageSideSize),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: .imageSideSize),
            
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            artistLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        artistLabel.text = viewModel.artist
        
        if let image = viewModel.thumbnail {
            thumbnailImageView.setPataImage(image)
        } else {
            thumbnailImageView.image = nil
        }
    }
}

private extension CGFloat {
    static let imageSideSize: CGFloat = 60
}
