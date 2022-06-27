//
//  HistoryView.swift
//  PataTest
//
//  Created by Franco on 27/06/22.
//

import UIKit
import PataCore

final class HistoryView: UIView {
    enum Action {
        case attemptToSelect(artworkId: Double)
    }
    var actionHandler: ((Action) -> Void) = { _ in }
    
    struct ViewModel {
        let items: [ArtworkUIModel]
    }
    var viewModel: ViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.cellId)
        return tableView
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
        addSubview(tableView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 500),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        tableView.reloadData()
    }
}

extension HistoryView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel, viewModel.items.indices.contains(indexPath.row) else { return }
        let artworkId = viewModel.items[indexPath.row].id
        actionHandler(.attemptToSelect(artworkId: artworkId))
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HistoryView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.items.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel,
              viewModel.items.indices.contains(indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.cellId, for: indexPath) as? HistoryTableViewCell
        else {
            fatalError("This should not happen")
        }
        let artwork = viewModel.items[indexPath.row]
        cell.configureCell(title: artwork.title,
                           subtitle: "",
                           date: artwork.dateDisplay,
                           image: artwork.image)
        return cell
    }
}
