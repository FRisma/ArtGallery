//
//  ListItemCollectionViewCell.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import Kingfisher
import UIKit
import PataCore

final class ListItemCollectionViewCell: UICollectionViewCell {
    static let cellId: String = "ListItemCollectionViewCell"
    
    private var imageDownloadTask: DownloadTask?
    
    private let artImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        artImageView.image = nil
        imageDownloadTask?.cancel()
    }
    
    func configureCell(image: PataImage?) {
        guard let image = image else { return }
        imageDownloadTask = artImageView.setPataImage(image)
    }
    
    private func setupSubviews() {
        addSubview(artImageView)
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            artImageView.topAnchor.constraint(equalTo: topAnchor),
            artImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            artImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            artImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
