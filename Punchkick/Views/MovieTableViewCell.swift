//
//  MovieTableViewCell.swift
//  Punchkick
//
//  Created by Donald Largen on 6/11/20.
//  Copyright © 2020 Donald Largen. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell, Reusable {

    @IBOutlet var movieImageView: PunchkickImageView!
    @IBOutlet var movieTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
