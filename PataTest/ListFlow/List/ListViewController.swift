//
//  ListViewController.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import UIKit

protocol ListViewControllerFactory {
    func makeListViewController() -> ListViewController
}

protocol ListViewControllerNavigationDelegate: AnyObject {
    func didTapItem(_ item: Artwork)
}

final class ListViewController: UIViewController {
    private let director: ListDirector
    private let viewModelFactory: ListViewModelFactory
    
    weak var navigationDelegate: ListViewControllerNavigationDelegate?
    
    private lazy var listView: ListView = {
        let view = ListView()
        view.actionHandler = { [weak self] action in
            self?.handleViewAction(action)
        }
        return view
    }()
    
    init(director: ListDirector, viewModelFactory: ListViewModelFactory) {
        self.director = director
        self.viewModelFactory = viewModelFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = listView
        director.stateListener = { [weak self] newState in
            DispatchQueue.main.async {
                self?.handleDirectorState(newState)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.title = "List"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        director.handleEvent(.viewIsReady)
    }
    
    // MARK: - Private methods
    
    private func handleViewAction(_ action: ListView.Action) {
        switch action {
        case .attemptToSelectArtworkId(let identifier):
            director.handleEvent(.attemptSelection(artId: identifier))
        case .attemptToShowLastItem:
            director.handleEvent(.attemptToSeeNextBatch)
        }
    }
    
    private func handleDirectorState(_ newState: ListDirector.State) {
        switch newState {
        case .didSelectArtwork(let artwork):
            navigationDelegate?.didTapItem(artwork)
        case .error(let errorMessage):
            showErrorView(message: errorMessage, action: { [weak self] in
                self?.director.handleEvent(.viewIsReady)
            })
        default:
            let newViewModel = viewModelFactory.makeViewModelFrom(newState, previousViewModel: listView.viewModel)
            listView.viewModel = newViewModel
        }
    }
}

