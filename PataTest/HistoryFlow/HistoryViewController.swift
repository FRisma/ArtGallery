//
//  HistoryViewController.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import UIKit

protocol HistoryViewControllerFactory {
    func makeHistoryViewController() -> HistoryViewController
}

protocol HistoryViewControllerNavigationDelegate: AnyObject {
    func didTapItem(_ item: Artwork)
}

final class HistoryViewController: UIViewController {
    
    weak var navigationDelegate: HistoryViewControllerNavigationDelegate?
    private let director: HistoryDirector
    
    private lazy var historyView: HistoryView = {
        let view = HistoryView()
        view.actionHandler = { [weak self] action in
            self?.handleViewAction(action)
        }
        return view
    }()
    
    // MARK: - Life cycle
    
    init(director: HistoryDirector) {
        self.director = director
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = historyView
        director.stateListener = { [weak self] newState in
            DispatchQueue.main.async {
                self?.handleDirectorState(newState)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.title = "History"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        director.handleEvent(.viewIsReady)
    }
    
    // MARK: - Private methods
    
    private func handleViewAction(_ action: HistoryView.Action) {
        switch action {
        case .attemptToSelect(artworkId: let artworkId):
            director.handleEvent(.attempToSelectAHistoricalItemId(artworkId))
        }
    }
    
    private func handleDirectorState(_ state: HistoryDirector.State) {
        switch state {
        case .initial(let artworks):
            historyView.viewModel = HistoryView.ViewModel(items: artworks)
        case .noRecords:
            break // TODO: @frisma
        case .didSelectIem(let artwork):
            navigationDelegate?.didTapItem(artwork)
        }
    }
}
