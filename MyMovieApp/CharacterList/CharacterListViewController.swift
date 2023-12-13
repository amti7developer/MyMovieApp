//
//  CharacterListViewController.swift
//  GameOfThronesFactsApp
//
//  Created by Kamil on 02/10/2020.
//  Copyright © 2020 Kamil Gacek. All rights reserved.
//

import UIKit
import TinyConstraints

final class CharacterListViewController: BaseViewController {
    
    private let searchController = UISearchController()
    
    var handleCharacterSelected: ((Movie) -> Void)?
    
    private struct Constants {
        static let cell = "cell"
        static let cellHeight: CGFloat = 100
        static let title = "Fresh Movies"
    }
    
    private var tableView = UITableView()
    private var viewModel: CharacterListViewModelType
    
    init(viewModel: CharacterListViewModelType) {
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

extension CharacterListViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell, for: indexPath) as? MovieCell, viewModel.movies.indices.contains(indexPath.row) else { return UITableViewCell() }

        let character = viewModel.movies[indexPath.row]
        cell.configure(with: character)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }

}

extension CharacterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleCharacterSelected?(viewModel.movies[indexPath.row])
    }
}

extension CharacterListViewController: CharacterListViewModelDelegate {
    func viewModelReloadData(_ viewModel: CharacterListViewModelType) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension CharacterListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        guard !(searchController.searchBar.text?.isEmpty ?? false) else {
            print("(*) empty!!!")
            viewModel.resetMovieList()
            tableView.reloadData()
            return
        }
        
        let updatedMovies = viewModel.moviesAll.filter { movie in
            movie.title?.contains(text) ?? false
        }
        
        viewModel.updateMovieList(movies: updatedMovies)
        
        
        updatedMovies.forEach {
            print("(*) ", $0.title)
        }
        
        tableView.reloadData()
        
        print("(*) TEXT:", text)
    }
    
}
