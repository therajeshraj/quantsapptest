//
//  FeedsTableViewCell.swift
//  QuantsFeed
//
//  Created by Rajesh on 15/08/20.
//  Copyright © 2020 Rajesh. All rights reserved.
//

import UIKit

class FeedsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var postProfile: UIImageView!
    @IBOutlet weak var postName: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var postDesc: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
