//
//  FeedTableViewCell.swift
//  Swift Photo Share
//
//  Created by Chuan Yu on 3/15/15.
//  Copyright (c) 2015 Chuan Yu. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    
    @IBOutlet weak var postedImage: UIImageView!
    
    @IBOutlet weak var imageTitle: UILabel!
    
    @IBOutlet weak var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
