//
//  MainCoordinator.swift
//  MyMovieApp
//
//  Created by Kamil on 03/10/2020.
//  Copyright © 2020 Kamil Gacek. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let dataFetcherService = DataFetcherService()
    private lazy var moviesListViewModel = MovieListViewModel(dataFetcherService: dataFetcherService)
    private lazy var moviesListViewController = MoviesListViewController(viewModel: moviesListViewModel)
    

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        moviesListViewController.handleMovieSelected = { [weak self] movie in
            self?.presentDetails(movie: movie)
        }

        navigationController.pushViewController(moviesListViewController, animated: true)
    }
    
    private func presentDetails(movie: Movie) {
        let detailsViewModel = DetailsViewModel(movie: movie)
        let detailsViewController = DetailsViewController(viewModel: detailsViewModel)
        detailsViewController.delegate = self
        detailsViewController.modalPresentationStyle = .fullScreen
        
        navigationController.present(detailsViewController, animated: true)
    }
}

extension MainCoordinator: DetailsViewControllerDelegate {
    func detailsViewControllerCloseTapped(_ view: DetailsViewController) {
        moviesListViewModel.reloadData()
    }
}
