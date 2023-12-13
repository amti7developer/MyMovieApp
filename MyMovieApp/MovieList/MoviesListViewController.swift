//
//  MoviesListViewController.swift
//  MyMovieApp
//
//  Created by Kamil on 02/10/2023.
//  Copyright © 2020 Kamil Gacek. All rights reserved.
//

import UIKit
import TinyConstraints

final class MoviesListViewController: BaseViewController {
    
    private let searchController = UISearchController()
    
    var handleMovieSelected: ((Movie) -> Void)?
    
    private var tableView = UITableView()
    private var viewModel: MovieListViewModelType
    
    init(viewModel: MovieListViewModelType) {
        self.viewModel = viewModel
        super.init()
        self.viewModel.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchCharaters()
        
        view.backgroundColor = .white
        navigationItem.title = Constants.title
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        
    }
    
    override func addSubviews() {
        view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        tableView.edgesToSuperview()
    }
    
    override func setupSubviews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: Constants.cell)

    }
}

extension MoviesListViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell, for: indexPath) as? MovieCell, viewModel.movies.indices.contains(indexPath.row) else { return UITableViewCell() }

        let Movie = viewModel.movies[indexPath.row]
        cell.configure(with: Movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }

}

extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleMovieSelected?(viewModel.movies[indexPath.row])
    }
}

extension MoviesListViewController: MovieListViewModelDelegate {
    func viewModelReloadData(_ viewModel: MovieListViewModelType) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension MoviesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        guard !(searchController.searchBar.text?.isEmpty ?? false) else {
            viewModel.resetMovieList()
            tableView.reloadData()
            return
        }
        
        let updatedMovies = viewModel.moviesAll.filter { movie in
            movie.title?.contains(text) ?? false
        }
        
        viewModel.updateMovieList(movies: updatedMovies)
        tableView.reloadData()
    }
    
}

extension MoviesListViewController {
    private struct Constants {
        static let cell = "cell"
        static let cellHeight: CGFloat = 100
        static let title = "Fresh Movies"
    }
}
