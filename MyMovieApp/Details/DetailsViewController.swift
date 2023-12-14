//
//  DetailsViewController.swift
//  MyMovieApp
//
//  Created by Kamil on 27/09/2020.
//  Copyright © 2020 Kamil Gacek. All rights reserved.
//

import UIKit

protocol DetailsViewControllerDelegate: AnyObject {
    func detailsViewControllerCloseTapped(_ view: DetailsViewController)
}

class DetailsViewController: BaseViewController {
    
    weak var delegate: DetailsViewControllerDelegate?
    
    private lazy var detailsView = DetailsView(viewModel: viewModel)
    private var viewModel: DetailsViewModelType
    
    override func loadView() {
        view = detailsView
    }
    
    init(viewModel: DetailsViewModelType) {
        self.viewModel = viewModel
        super.init()

        detailsView.delegate = self
    }
    
    override func viewDidLoad() {
        detailsView.configureView(movie: viewModel.movie)
    }
}

extension DetailsViewController: DetailsViewDelegate {
    func detailsViewCloseTapped(_ view: DetailsView) {
        delegate?.detailsViewControllerCloseTapped(self)
        dismiss(animated: true)
    }
}
