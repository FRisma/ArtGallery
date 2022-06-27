//
//  ListView.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import PataCore
import UIKit

final class ListView: UIView {
    enum Action {
        case attemptToSelectArtworkId(Double)
        case attemptToShowLastItem
    }
    
    struct ViewModel {
        let items: [ArtworkUIModel]
        let lastSeen: ArtworkUIModel?
    }
    
    var viewModel: ViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    var actionHandler: ((Action) -> Void) = { _ in }
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ListItemCollectionViewCell.self, forCellWithReuseIdentifier: ListItemCollectionViewCell.cellId)
        return collectionView
    }()
    
    private var lastSeenCardTopConstraint: NSLayoutConstraint!
    private lazy var lastSeenCard: LastSeenCardView = {
        let view = LastSeenCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        view.isHidden = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapLastSeen))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        return view
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
        addSubview(collectionView)
        addSubview(lastSeenCard)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        lastSeenCardTopConstraint = lastSeenCard.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            lastSeenCardTopConstraint,
            lastSeenCard.heightAnchor.constraint(equalToConstant: .lastSeenCardHeight),
            lastSeenCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            lastSeenCard.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        collectionView.reloadData()
        
        if let lastSeenItem = viewModel.lastSeen {
            showLastSeenCard(lastSeenItem)
        }
    }
    
    private func showLastSeenCard(_ artwork: ArtworkUIModel) {
        lastSeenCard.viewModel = LastSeenCardView.ViewModel(title: artwork.title, artist: artwork.artistDisplay, thumbnail: artwork.image)
        lastSeenCard.isHidden = false
        lastSeenCardTopConstraint.constant = -.lastSeenCardHeight
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    @objc
    private func didTapLastSeen() {
        guard let artId = viewModel?.lastSeen?.id else { return }
        actionHandler(.attemptToSelectArtworkId(artId))
    }
}


extension ListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.items.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel,
              viewModel.items.indices.contains(indexPath.item),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListItemCollectionViewCell.cellId, for: indexPath) as? ListItemCollectionViewCell
        else {
            fatalError("Something went terribly wrong")
        }
        cell.configureCell(image: viewModel.items[indexPath.item].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel, viewModel.items.indices.contains(indexPath.item) else { return }
        collectionView.deselectItem(at: indexPath, animated: false)
        actionHandler(.attemptToSelectArtworkId(viewModel.items[indexPath.item].id))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        if indexPath.row == viewModel.items.endIndex - 3 {
            actionHandler(.attemptToShowLastItem)
        }
    }
}

private extension CGFloat {
    static let lastSeenCardHeight: CGFloat = 70
}
