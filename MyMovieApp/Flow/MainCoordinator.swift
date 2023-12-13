//
//  MainCoordinator.swift
//  GameOfThronesFactsApp
//
//  Created by Kamil on 03/10/2020.
//  Copyright © 2020 Kamil Gacek. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let viewModel = CharacterListViewModel()
    private lazy var characterListViewController = CharacterListViewController(viewModel: viewModel)
    

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        characterListViewController.handleCharacterSelected = { [weak self] movie in
            self?.presentDetails(movie: movie)
        }

        navigationController.pushViewController(characterListViewController, animated: true)
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
        viewModel.reloadData()
        
    }
}
