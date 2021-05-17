//
//  PostTableViewCell.swift
//  cogniwideAssesment
//
//  Created by Keyur Patel on 14/05/21.
//  Copyright © 2021 cogniwide. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCellData(title:String,description:String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
