//
//  MovieDetailViewController.swift
//  Punchkick
//
//  Created by Donald Largen on 6/15/20.
//  Copyright © 2020 Donald Largen. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, Reusable {

    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieMetacriticScore: UILabel!
    @IBOutlet var moviePlotLabel: UILabel!
    
    var viewModel: MovieDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTitleLabel.text = viewModel.movieTitle
        movieMetacriticScore.text = viewModel.score
        moviePlotLabel.text = viewModel.plot
        
        viewModel.movieImage { [weak self ](result) in
            switch result {
            case .success(let image):
                self?.movieImageView.image = image
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
