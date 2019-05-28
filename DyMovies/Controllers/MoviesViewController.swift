//
//  MoviesViewController.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 25/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {

    @IBOutlet weak var yearButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var movieList: [Movie] = []
    var page: Int = 0
    var totalResults: Int = 0
    var totalPages: Int = 0
    
    var year: Int = Date().year {
        didSet {
            yearButton.setTitle("\(year)", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "movieCellId")
        
        year = Date().year
        loadMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers
    
    func loadMovies(page: Int = 1) {
        
        Services.shared.discoverMovies(year: year, page: page) { [weak self] (movies, error) in
            guard let weakSelf = self else { return }
            
            if let movies = movies {
                weakSelf.movieList = movies.results
                weakSelf.totalResults = movies.totalResults
                weakSelf.totalPages = movies.totalPages
                
                weakSelf.collectionView.reloadData()
            }
            else if let error = error {
                print(error.localizedDescription)
            }
            else {
                print("[Error] Unexpected response")
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func yearButtonTapped(_ sender: UIButton) {
    
        presentYearsViewController(selectedYear: year, sourceView: sender) { (year) in
            
            self.dismiss(animated: true, completion: {
                self.year = year
                self.loadMovies()
            })
        }
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension MoviesViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            let movie = movieList[indexPath.item]
            if let url = movie.posterUrl {
                Services.shared.downloadImage(from: url) { _ in }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
}

// MARK: - UICollectionViewDataSource
extension MoviesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCellId", for: indexPath) as! MovieViewCell
        let tag = cell.tag + 1
        cell.tag = tag
        
        let movie = movieList[indexPath.item]
        cell.titleLabel.text = movie.title
        cell.subtitleLabel.text = movie.releaseDate.string(with: "MMMM dd, yyyy")
        
        cell.imageView.image = nil
        if let url = movie.posterUrl {
            Services.shared.downloadImage(from: url) { (image) in
                if cell.tag == tag {
                    cell.imageView.image = image
                }
            }
        }
        
        if movie.voteAverage == 0 {
            cell.voteLabel.text = "?"
            cell.voteLabel.textColor = UIColor.white
        }
        else {
            cell.voteLabel.text = String(format: "%.1f", movie.voteAverage)
            if movie.voteAverage >= 7 {
                cell.voteLabel.textColor = UIColor.green
            }
            else if movie.voteAverage <= 4 {
                cell.voteLabel.textColor = UIColor.red
            }
            else {
                cell.voteLabel.textColor = UIColor.yellow
            }
        }
        
        cell.overviewLabel.text = movie.overview
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (UIScreen.main.bounds.width - 8 * 2)
        let height: CGFloat = 186.0
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDelegate
extension MoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movie = movieList[indexPath.item]
        showMovieViewController(movie)
    }
}


