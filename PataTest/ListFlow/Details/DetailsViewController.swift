//
//  DetailsViewController.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import UIKit

protocol DetailsViewControllerFactory {
    func makeDetailsViewController(artwork: Artwork) -> DetailsViewController
}

final class DetailsViewController: UIViewController {
    
    private lazy var detailsView: DetailsView = {
        let view = DetailsView()
        view.actionHandler = { [weak self] action in
            self?.handleViewAction(action)
        }
        return view
    }()
    
    private let director: DetailsDirector
    
    init(director: DetailsDirector) {
        self.director = director
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailsView
        
        director.stateListener = { [weak self] newState in
            DispatchQueue.main.async {
                self?.handleDirectorState(newState)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        director.handleEvent(.viewIsReady)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Private methods
    
    private func handleViewAction(_ action: DetailsView.Action) {
        switch action {
        case .attemptToSeeMore:
            director.handleEvent(.moreInfo)
        }
    }
    
    private func handleDirectorState(_ state: DetailsDirector.State) {
        switch state {
        case .initial(let model):
            detailsView.viewModel = DetailsView.ViewModel(image: model.image,
                                                          title: model.title,
                                                          artist: model.artistDisplay,
                                                          artistDetails: nil)
        case .didFetchExtraInfo(let artistInfo):
            guard let previousViewModel = detailsView.viewModel else { return }
            detailsView.viewModel = DetailsView.ViewModel(image: previousViewModel.image,
                                                          title: previousViewModel.title,
                                                          artist: previousViewModel.artist,
                                                          artistDetails: artistInfo)
        }
    }
}
