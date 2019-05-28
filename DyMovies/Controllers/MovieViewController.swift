//
//  MovieViewController.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 25/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = movie?.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIViewController
extension UIViewController {
    
    func showMovieViewController(_ movie: Movie) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "movie") as! MovieViewController
        viewController.movie = movie
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
