//
//  MovieViewCell.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 25/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//

import UIKit

class MovieViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    func setupViews() {
        
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 1
        
        voteLabel.layer.cornerRadius = voteLabel.frame.width / 2
        voteLabel.layer.masksToBounds = true
    }
}
