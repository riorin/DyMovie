//
//  ProfileViewController.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 25/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var favoritedMoviesLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movieList: [Movie] = []
    var page: Int = 0
    var totalResults: Int = 0
    var totalPages: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        reloadProfile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers
    
    func setupViews() {
        
        collectionView.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "movieCellId")
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.masksToBounds = true
        
        loginButton.layer.cornerRadius = 3
        loginButton.layer.masksToBounds = true
        loginButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        loginButton.layer.borderWidth = 1
    }
    
    func reloadProfile() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if Session.currentSession(in: context) != nil,
            let profile = Profile.currentProfile(in: context) {
            
            nameLabel.text = (profile.name ?? "").isEmpty ? profile.username : profile.name
            nameLabel.backgroundColor = UIColor.clear
            loginButton.setTitle("Logout", for: .normal)
            loginButton.setTitleColor(UIColor.red, for: .normal)
            
            if let url = profile.avatarUrl {
                Services.shared.downloadImage(from: url) { (image) in
                    self.profileImageView.image = image
                }
            }
            
            favoritedMoviesLabel.isHidden = false
            loadFavoritedMovies()
        }
        else {
            
            nameLabel.text = nil
            nameLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            loginButton.setTitle("Login", for: .normal)
            loginButton.setTitleColor(UIColor(red: 0, green: 122.0/255.0, blue: 1, alpha: 1), for: .normal)
            
            profileImageView.image = nil
            
            movieList = []
            favoritedMoviesLabel.isHidden = true
            collectionView.reloadData()
        }
    }
    
    func login() {
        
        presentLoginViewController {
            self.reloadProfile()
        }
    }
    
    func logout() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if let profile = Profile.currentProfile(in: context) {
            context.delete(profile)
        }
        if let session = Session.currentSession(in: context) {
            context.delete(session)
        }
        
        appDelegate.saveContext()
        
        reloadProfile()
    }
    
    func loadFavoritedMovies(page: Int = 1) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let profileId = Profile.currentProfile(in: context)?.profileId,
            let sessionId = Session.currentSession(in: context)?.sessionId else {
                
            return
        }
        
        Services.shared.favoritedMovies(profileId: profileId, sessionId: sessionId) { [weak self] (movies, error) in
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
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if Session.currentSession(in: context) != nil {
            
            let alert = UIAlertController(title: "Logout", message: "Are you sure to logout?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                self.logout()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else {
            login()
        }
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension ProfileViewController: UICollectionViewDataSourcePrefetching {
    
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
extension ProfileViewController: UICollectionViewDataSource {
    
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
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
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
extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movie = movieList[indexPath.item]
        showMovieViewController(movie)
    }
}
