//
//  MovieListViewController.swift
//  Punchkick
//
//  Created by Donald Largen on 6/11/20.
//  Copyright © 2020 Donald Largen. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController {

    @IBOutlet var movieTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private var searchController: UISearchController!
    private let viewModel: MovieSearchViewModel = MovieSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let selected = self.movieTableView.indexPathForSelectedRow {
            movieTableView.deselectRow(at: selected, animated: true)
        }
    }
    
    private func setupUI() {
        self.navigationItem.title = "Movie Search"
        movieTableView.rowHeight = UITableView.automaticDimension
        movieTableView.estimatedRowHeight = 100
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.barStyle = .default
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = true
        searchController.searchBar.barTintColor = UIColor(named: "searchbar_tint")
        searchController.searchBar.searchTextField.backgroundColor = .white
        movieTableView.tableHeaderView = searchController.searchBar
    }
}

extension MovieSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.searchTextField.text else { return }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        self.viewModel.search(for: searchText) { [weak self] (result) in
            self?.activityIndicator.isHidden = true
            switch result {
            case .success( _):
                self?.searchController.dismiss(animated: true, completion: nil)
                self?.movieTableView.reloadData()
            case .failure(let error ):
                let msg = error.localizedDescription
                let alert = UIAlertController(title: "OOPS", message: msg, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler:nil)
                alert.addAction(action)
                self?.searchController.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension MovieSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell: MovieTableViewCell = movieTableView.dequeueReusableCell(indexPath: indexPath)
        movieCell.movieTitleLabel.text = self.viewModel.movieTitle(at: indexPath)
        movieCell.movieImageView.image = nil
        movieCell.movieImageView.indexPath = indexPath
        
        viewModel.movieImage(at: indexPath) { (image , path) in
            guard let storedPath = movieCell.movieImageView.indexPath, path == storedPath else {
                movieCell.movieImageView.image = nil
                return
            }
           movieCell.movieImageView.image = image
        }
        return movieCell
    }
}

extension MovieSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        viewModel.movieDetail(at: indexPath) {[weak self] (result) in
            self?.activityIndicator.isHidden = true
            
            switch result {
            case .success(let detail):
                let movieDetailVC = UIStoryboard.movieDetailViewController()
                movieDetailVC.viewModel = MovieDetailViewModel(movieDetail: detail)
                self?.navigationController?.pushViewController(movieDetailVC, animated: true)
            case .failure(let error):
                let msg = error.localizedDescription
                let alert = UIAlertController(title: "OOPS", message: msg, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler:nil)
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}




