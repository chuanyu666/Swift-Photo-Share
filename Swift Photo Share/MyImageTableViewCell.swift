//
//  MyImageTableViewCell.swift
//  Swift Photo Share
//
//  Created by Chuan Yu on 3/17/15.
//  Copyright (c) 2015 Chuan Yu. All rights reserved.
//

import UIKit

class MyImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postedImage: UIImageView!

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
