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
        let isMoreInfoEnabled: Bool
        let artistDetails: Artist?
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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
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
        return button
    }()
    
    private let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
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
        addSubview(scrollView)
        scrollView.addSubview(artImageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(subtitleLabel)
        scrollView.addSubview(moreInfoButton)
        scrollView.addSubview(detailsStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            
            artImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            artImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            artImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            artImageView.heightAnchor.constraint(equalToConstant: 500),
            
            titleLabel.topAnchor.constraint(equalTo: artImageView.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            moreInfoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            moreInfoButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            
            detailsStackView.topAnchor.constraint(equalTo: moreInfoButton.bottomAnchor, constant: 4),
            detailsStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailsStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    private func OLDsetSubviews() {
        backgroundColor = .systemGray
        addSubview(artImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(moreInfoButton)
        addSubview(detailsStackView)
    }
    
    private func OLDsetConstraints() {
        NSLayoutConstraint.activate([
            artImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            artImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            artImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            artImageView.heightAnchor.constraint(equalToConstant: 500),
            
            titleLabel.topAnchor.constraint(equalTo: artImageView.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            moreInfoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            moreInfoButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            
            detailsStackView.topAnchor.constraint(equalTo: moreInfoButton.bottomAnchor, constant: 4),
            detailsStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailsStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.artist
        
        if let image = viewModel.image {
            artImageView.setPataImage(image)
        }
        
        moreInfoButton.isHidden = !viewModel.isMoreInfoEnabled
        
        if let artistDetails = viewModel.artistDetails {
            fillDetailsView(artistDetails)
            moreInfoButton.isHidden = true
        }
    }
    
    @objc
    private func didTapSeeMore() {
        actionHandler(.attemptToSeeMore)
    }
    
    private func fillDetailsView(_ artist: Artist) {
        detailsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let row = createDetailRow(title: "Full Name", value: artist.title)
        detailsStackView.addArrangedSubview(row)
        
        if let description = artist.description {
            let row = createDetailRow(title: "Description", value: description)
            detailsStackView.addArrangedSubview(row)
        }
        
        if let birthDate = artist.birthDate {
            let row = createDetailRow(title: "Birth", value: "\(birthDate)")
            detailsStackView.addArrangedSubview(row)
        }
        
        if let birthPlace = artist.birthPlace {
            let row = createDetailRow(title: "Birth Place", value: birthPlace)
            detailsStackView.addArrangedSubview(row)
        }
        
        if let deathDate = artist.deathDate {
            let row = createDetailRow(title: "Death Date", value: "\(deathDate)")
            detailsStackView.addArrangedSubview(row)
        }
        
        if let deathPlace = artist.deathPlace {
            let row = createDetailRow(title: "Death Place", value: deathPlace)
            detailsStackView.addArrangedSubview(row)
        }
    }
    
    private func createDetailRow(title: String, value: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.text = title
        
        let valueLabel = UILabel()
        valueLabel.numberOfLines = 0
        valueLabel.text = value
        
        let horizontalStackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        
        return horizontalStackView
    }
}

